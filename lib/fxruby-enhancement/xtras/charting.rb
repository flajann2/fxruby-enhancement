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
            raise "layout error in #{self.class}" if x.nil? or y.nil? or width.nil? or heigth.nil?
            dc.foreground = black
            dc.drawRectangle x, y, width, height
          end
          
          def enabled? ; enabled ; end
          def floating? ; floating ; end

          # calc the width and height of this box. Override!
          def calculate_dimensions
            width  = hint_width  if width.nil?
            height = hint_height if height.nil?
          end
          
          def initialize float: false, enabled: true, dom: 1
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
          def initialize
            super
            @dominance = 0
          end

          # null box is never rendered.
          def render dc
          end
        end
        
        class PureText < Box
        end
        
        class Title < PureText
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
        
        class Caption < PureText
        end

        class Legend < Box
        end

        # main charting area.
        class Graph < Box
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
            @layout = lyt = { null_box: NullBox.new,
                              title: Title.new,
                              top_ruler: TopRuler.new,
                              bottom_ruler: BottomRuler.new,
                              left_ruler: LeftRuler.new,
                              right_ruler: RightRuler.new,
                              caption: Caption.new,
                              legend: Legend.new,
                              graph: Graph.new }
            # bottom connections
            lyt[:null_box].bottom_box     = lyt[:title]
            lyt[:title].bottom_box        = lyt[:top_ruler]
            lyt[:top_ruler].bottom_box    = lyt[:graph]
            lyt[:graph].bottom_box        = lyt[:bottom_ruler]
            lyt[:bottom_ruler].bottom_box = lyt[:caption]
            lyt[:caption].bottom_box      = lyt[:null_box]

            # right connections
            lyt[:null_box].right_box      = lyt[:left_ruler]
            lyt[:left_ruler].right_box    = lyt[:graph]
            lyt[:graph].right_box         = lyt[:right_ruler]
            lyt[:right_ruler].right_box   = lyt[:legend]
            lyt[:legend].right_box        = lyt[:null_box]
            
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
          
          # Layout given box, as much as possible, given neighbors.
          # may be called twice per box.
          # 
          def layout_box box
            if box.dominance == 0 # the only box with a dom of 0 is the null box
              box.x = box.y = 0
              box.width = width
              box.height = height
            else # we do what we can.
              box.calculate_dimensions
              subordinates(box).each{ |sub|
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
                  puts "-->unresolved: #{e}"
                end
              }
              
              superiors(box).each{ |sup|
                case sup
                when box.left_box
                when box.right_box
                when box.top_box
                when box.bottom_box                  
                end
              }
            end
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

