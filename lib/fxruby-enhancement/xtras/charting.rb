# coding: utf-8

module Fox
  module Enhancement
    module Xtras
      # Charting constructs. Note that the
      # rulers have built-in their own labeling, with orientation.
      module Charting
        
        # Box area of drawing interest. This is
        # more virtual than actual, i.e. no clipping
        # is performed.
        class Box
          include RGB
          MAX_DOMINANCE = 3
          NÄHE = [:top_box, :bottom_box, :left_box, :right_box]

          # Name of this box -- we use this in some cases to avoid class polution
          attr_reader :name
          
          # coordinate and dimensions of the box
          attr_accessor :x, :y, :width, :height

          # hints on width and heigt, if meaningful, otherwise nil
          attr_accessor :hint_width, :hint_height
          
          # textual orientation :horizontal, :vertical
          attr_accessor :orientation

          # adjoining boxes 
          attr_accessor :top_box, :bottom_box
          attr_accessor :left_box, :right_box

          # margins
          attr_accessor :top_margin, :bottom_margin, :left_margin, :right_margin

          attr_accessor :enabled, :floating

          # dominance rating (must be supplied)
          attr_accessor :dominance

          # always overide this the default simply renders a box
          def render dc
            raise "layout error in #{self.class}" if x.nil? or y.nil? or width.nil? or height.nil?
            dc.foreground = black
            dc.drawRectangle x, y, width, height
          end
          
          def enabled? ; enabled ; end
          def floating? ; floating ; end

          # calc the width and height of this box. Override!
          def calculate_dimensions
            self.width  ||= (hint_width || 20) #TODO: remove the cheats
            self.height ||= (hint_height || 10)
          end
          
          def initialize float: false, enabled: true, dom: 1
            @name = self.class 
            @dominance = dom
            @floating = float
            @top_margin = @bottom_margin = @left_margin = @right_margin = 0
            @orientation = :horizontal
            @enabled = enabled
          end
        end

        # The null box represents the side of the container -- the
        # canvas -- and will simplify layout.
        class NullBox < Box
          def initialize name = nil
            super()
            @name = name unless name.nil?
            @dominance = 0
          end

          # null box is never rendered.
          def render dc
          end
        end              
        
        class Ruler < Box
          def initialize
            super
            @dominance = 2
          end
        end
        
        class TopRuler < Ruler
        end
        
        class BottomRuler < Ruler
        end
        
        class LeftRuler < Ruler
        end
        
        class RightRuler < Ruler
        end

        # For now, we assume that the placement
        # of PureText boxes shall be above and
        # below the GraphBox.
        class PureText < Box
          def calculate_wh
          end
          
          def calculate_dimensions
            super
            calculate_wh
            begin
              self.x = [top_box.width, bottom_box.width].max / 2 - self.width / 2
            rescue ArgumentError, NoMethodError, TypeError => e
              puts "-->PureText unresolved: #{e}"
            end
          end
        end

        class Title < PureText
        end

        class Caption < PureText
        end

        class Legend < Box
          # We calculate this on the basis
          # of our actual content.
          def calculate_wh
            self.width = 50 # TODO: we're cheating again.
            self.height = 30
          end
          
          def calculate_dimensions
            super
            calculate_wh
            
            # This is a nasty hard-coding, which will not
            # allow us to change the location of this box.
            # Later, we'll want to add that flexibility.
            self.y = right_box.height / 2 - self.height / 2
          end
        end

        # main charting area.
        class Graph < Box
          def calculate_dimensions
            super
            begin
              self.width = right_box.x
                           - right_box.left_margin
                           - left_box.x
                           + left_box.width
                           + left_box.right_margin
              self.height = bottom_box.y
                           - bottom_box.top_margin
                           - top_box.y
                           + top_box.height
                           + top_box.bottom_margin
            rescue NoMethodError, TypeError => e
              puts "-->Graph: unresolved: #{e}"
            end
          end
          
          def initialize
            super
            @dominance = 3
          end
        end
        
        class Chart
          extend Forwardable
          include RGB
          
          def_delegators :@canvas, :width, :height, :visual
          def_delegators :@cos, :type,
                         :axial, :data, :series, :domain, :range,
                         :background, :caption, :title
          
          attr_accessor :buffer
          
          def initialize cos, canvas
            @cos = cos
            @canvas = canvas
            as (:app) {
              @buffer = fx_image { opts IMAGE_KEEP }
            }
            # detailed chart parameters
            @x_ruler_width = 20
            @y_ruler_height = 20
            @font_title = nil
            @font_caption = nil
            @font_ledgend = nil
            @font_axis_name = nil

            # chart layout
            @layout = lyt = { null_left: NullBox.new(:left),
                              null_right: NullBox.new(:right),
                              null_top: NullBox.new(:top),
                              null_bottom: NullBox.new(:bottom),
                              title: Title.new,
                              top_ruler: TopRuler.new,
                              bottom_ruler: BottomRuler.new,
                              left_ruler: LeftRuler.new,
                              right_ruler: RightRuler.new,
                              caption: Caption.new,
                              legend: Legend.new,
                              graph: Graph.new }
            # bottom connections
            lyt[:null_top].bottom_box     = lyt[:title]
            lyt[:title].bottom_box        = lyt[:top_ruler]
            lyt[:top_ruler].bottom_box    = lyt[:graph]
            lyt[:graph].bottom_box        = lyt[:bottom_ruler]
            lyt[:bottom_ruler].bottom_box = lyt[:caption]
            lyt[:caption].bottom_box      = lyt[:null_bottom]

            # right connections
            lyt[:null_left].right_box     = lyt[:left_ruler]
            lyt[:left_ruler].right_box    = lyt[:graph]
            lyt[:graph].right_box         = lyt[:right_ruler]
            lyt[:right_ruler].right_box   = lyt[:legend]
            lyt[:legend].right_box        = lyt[:null_right]
            
            backlink_boxes
          end

          def backlink_boxes
            @layout.each{ |name, box|
              box.bottom_box.top_box = box unless box.bottom_box.nil?
              box.right_box.left_box = box unless box.right_box.nil?
            }
          end

          # call inially and when there's an update.
          def layout_boxes
            clear_all_boxes
            recalculate_dimensions
            
            # first pass -- out to in
            (0..Box::MAX_DOMINANCE).each do |dom|
              boxes_of_dominance(dom).each{ |box| layout_box box }
            end
            
            # second pass -- in to out
            (1..Box::MAX_DOMINANCE).to_a.reverse.each do |dom|
              boxes_of_dominance(dom).each{ |box| layout_box box }
            end
          end

          # All x,y,width,height are nilled for all boxes
          def clear_all_boxes
            @layout.each { |name, box|
              box.x = box.y = box.width = box.height = nil
            }
          end

          def recalculate_dimensions
            @layout.each { |name, box|
              box.calculate_dimensions
            }
          end
          
          # Layout given box, as much as possible, given neighbors.
          # may be called twice per box.
          # 
          def layout_box box
            if box.dominance == 0 # the only box with a dom of 0 are the null boxes
              case box.name
              when :left
                box.x = 0
                box.y = 0
                box.width = 0
                box.height = height
              when :right
                box.x = width
                box.y = 0
                box.width = 0
                box.height = height
              when :top
                box.x = 0
                box.y = 0
                box.width = width
                box.height = 0
              when :bottom
                box.x = 0
                box.y = height
                box.width = width
                box.height = 0
              end              
            else # we do what we can.
              box.calculate_dimensions
              subordinates(box).each { |sub|
                begin
                  case sub
                  when box.left_box
                    box.x = sub.x + sub.width + sub.right_margin + box.left_margin
                  when box.right_box
                    box.x = sub.x - sub.left_margin - box.right_margin - box.width
                  when box.top_box
                    box.y = sub.y + sub.height + sub.bottom_margin + box.top_margin
                  when box.bottom_box                  
                    box.y = sub.y - sub.top_margin - box.bottom_margin - box.height
                  end
                rescue NoMethodError, TypeError => e
                  puts "-->subortinate unresolved: #{e}"
                end
              }
              
              superiors(box).each { |sup|
                begin
                  case sup
                  when box.left_box
                    box.height = sup.height 
                    box.x
                  when box.right_box
                  when box.top_box
                  when box.bottom_box                  
                  end
                rescue NoMethodError, TypeError => e
                  puts "-->superior unresolved: #{e}"
                end unless box.floating?
              }
            end
            puts "#{box.name} dom=#{box.dominance} x=#{box.x||'NIL'} y=#{box.y||'NIL'} width=#{box.width||'NIL'} height=#{box.height||'NIL'}"
          end

          # Give a list of subordinates
          def subordinates box
            Box::NÄHE.map{ |b| box.send(b) }
              .compact
              .select { |nbox| box.dominance > nbox.dominance }            
          end
          
          # Give a list of superiors
          def superiors box
            Box::NÄHE.map{ |b| box.send(b) }
              .compact
              .select { |nbox| box.dominance < nbox.dominance }            
          end          

          # return all boxes with the proscribed dominance
          def boxes_of_dominance dom
            @layout.map{ |name, box| box }.select{ |box| box.dominance == dom }
          end
          
          def draw_dc &block
            @buffer.starten if @buffer.inst.nil?
            FXDCWindow.new(@buffer.inst) { |dc| block.(dc) }
          end
          
          def update_chart
            layout_boxes
            draw_dc { |dc|
              dc.setForeground white
              dc.fillRectangle 0, 0, width, height
              dc.drawImage @buffer.inst, 0, 0
              @layout.each{ |name, box| box.render(dc) }
            }
            @canvas.update
          end
        end
      end
    end
      
    module Mapper
      def fx_chart name = nil,
                   ii: 0,
                   pos: Enhancement.stack.last,
                   reuse: nil,
                   &block
        Enhancement.stack << (@os = os =
                              OpenStruct.new(klass: FXCanvas,
                                               op: [],
                                               ii: ii,
                                               fx: nil,
                                               kinder: [],
                                               inst: nil,
                                               instance_result: nil,
                                               reusable: reuse,
                                               type: :cartesian,
                                               axial: OpenStruct.new,
                                               background: OpenStruct.new,
                                               caption: OpenStruct.new,
                                               title: OpenStruct.new))
        Enhancement.components[name] = os unless name.nil?
        unless pos.nil?
          pos.kinder << os 
        else
          Enhancement.base = os
        end
        
        @os.op[0] = OpenStruct.new(:parent => :required,
                                     :target => nil,
                                     :selector => 0,
                                     :opts => FRAME_NORMAL,
                                     :x => 0,
                                     :y => 0,
                                     :width => 0,
                                     :height => 0)
        
        # Initializers for the underlying 
        def target var; @os.op[@os.ii].target = var; end
        def selector var; @os.op[@os.ii].selector = var; end
        def opts var; @os.op[@os.ii].opts = var; end
        def x var; @os.op[@os.ii].x = var; end
        def y var; @os.op[@os.ii].y = var; end
        def width var; @os.op[@os.ii].width = var; end
        def height var; @os.op[@os.ii].height = var; end
        
        # Chart specific
          def type var; @os.type = var; end
          
          def axis ax, **kv
            @os.axial[ax] = OpenStruct.new(**kv)
          end
          
          def data *dat; @os.data = dat; end        
          def series ser; @os.series = ser; end
          def domain a, b; @os.domain = [a, b]; end
          def range a, b; @os.range = [a, b]; end
          
          def background **kv; kv.each{ |k,v| @os.background[k] = v }; end
          def caption **kv; kv.each{ |k,v| @os.caption[k] = v }; end
          def title **kv; kv.each{ |k,v| @os.title[k] = v }; end
          
          # What will be executed after FXCanvas is created.
          def instance aname=nil, &block
            @os.instance_name = aname
            @os.instance_block ||= []
            @os.instance_block << [aname, block]
          end
          
          # Internal use only.
          def chart_instance os, &block
            os.instance_name = nil
            os.instance_block ||= []
            os.instance_block << [nil, block]
            return os
          end
          
          self.instance_eval &block
          
          os.fx = ->(){
            chart_instance (os) { |c|
              os.chart = Xtras::Charting::Chart.new os, c
              os.inst.instance_variable_set(:@chart, os.chart)
            }
            
            c = FXCanvas.new(*([pos.inst] + os.op[os.ii].to_h.values[1..-1]
                                            .map{ |v| (v.is_a?(OpenStruct) ? v.inst : v)} ))
            c.extend SingleForwardable
            c.def_delegators :@chart, :update_chart
            c.sel_configure { |sender, sel, event|
              os.chart.buffer.starten if os.chart.buffer.inst.nil?
              bb = os.chart.buffer.inst
              bb.create unless bb.created?
              bb.resize sender.width, sender.height
            }
            c.sel_paint { |sender, sel, event|
              FXDCWindow.new(sender, event) { |dc|
                os.chart.buffer.starten if os.chart.buffer.inst.nil?
                dc.drawImage(os.chart.buffer.inst, 0, 0)
              }
            }
            c
          }
          
          Enhancement.stack.pop                                                  
          @os = Enhancement.stack.last
          return os
      end
    end
  end
end

