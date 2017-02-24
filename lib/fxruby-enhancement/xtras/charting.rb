# coding: utf-8
require_relative 'charting-boxes'

module Fox
  module Enhancement
    module Xtras
      # Charting constructs. Note that the
      # rulers have built-in their own labeling, with orientation.
      module Charting
        # range in real coordinates, beginning and end points
        class Range
          attr_accessor :x1, :y1, :x2, :y2
          
          def initialize x1, y1, x2, y2
            @x1 = x1
            @y1 = y1
            @x2 = x2
            @y2 = y2
          end
        end
        
        class Chart
          extend Forwardable
          include RGB
          
          def_delegators :@canvas, :width, :height, :visual
          def_delegators :@cos, :type,
                         :axial, :data, :series, :domain, :range,
                         :background, :caption, :title
          
          attr_accessor :buffer, :x_range, :y_range
          
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
            lytbox = ->(klass, **kv){ [kv[:name], klass.new(self, **kv)] }
            @layout = lyt = [
              lytbox.(NullBox, name: :null_left,    placement: :left),
              lytbox.(NullBox, name: :null_right,   placement: :right),
              lytbox.(NullBox, name: :null_top,     placement: :top),
              lytbox.(NullBox, name: :null_bottom,  placement: :bottom),
              lytbox.(Title,   name: :title,        float: true),
              lytbox.(Ruler,   name: :top_ruler,    axial: @cos.axial, orient: :horizontal, placement: :top),
              lytbox.(Ruler,   name: :bottom_ruler, axial: @cos.axial, orient: :horizontal, placement: :bottom),
              lytbox.(Ruler,   name: :left_ruler,   axial: @cos.axial, orient: :vertical,   placement: :left),
              lytbox.(Ruler,   name: :right_ruler,  axial: @cos.axial, orient: :vertical,   placement: :right),
              lytbox.(Caption, name: :caption,      float: true),
              lytbox.(Legend,  name: :legend,       float: true),
              lytbox.(Graph,   name: :graph)
            ].to_h
            
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

          
          # Layout given box, as much as possible, given neighbors.
          # may be called twice per box.
          # 
          def layout_box box
            if box.dominance == 0 # the only box with a dom of 0 are the null boxes
              case box.name
              when :null_left
                box.x = 0
                box.y = 0
                box.width = 0
                box.height = height
              when :null_right
                box.x = width
                box.y = 0
                box.width = 0
                box.height = height
              when :null_top
                box.x = 0
                box.y = 0
                box.width = width
                box.height = 0
              when :null_bottom
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
                  #puts "-->subortinate unresolved: #{e}"
                end
              }
              
              superiors(box).each { |sup|
                begin
                  case sup
                  when box.left_box
                    box.height = sup.height 
                    box.y = sup.y
                    box.x = sup.x + sup.width + sup.right_margin + box.left_margin
                  when box.right_box
                    box.height = sup.height
                    box.y = sup.y                                        
                  when box.top_box
                    box.width = sup.width
                    box.x = sup.x
                  when box.bottom_box
                    box.width = sup.width
                    box.x = sup.x
                  end
                rescue NoMethodError, TypeError => e
                  #puts "-->superior unresolved: #{e}"
                end unless box.floating?
              }
            end
          end

          
          def draw_dc &block
            @buffer.starten if @buffer.inst.nil?
            FXDCWindow.new(@buffer.inst) { |dc| block.(dc) }
          end
          
          def update_chart
            layout_boxes
            draw_dc { |dc|
              dc.setForeground @cos.background.color || white
              dc.fillRectangle 0, 0, width, height
              dc.drawImage @buffer.inst, 0, 0
              @layout.map{ |name, box| box }
                .reject{ |box| box.nil? }
                .select{ |box| box.enabled? }
                .each{ |box| box.render(dc) }
            }
            @canvas.update
          end

          private
          
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
          
          # Give a list of subordinates
          def subordinates box
            Box::NÄHE.map{ |b| box.send(b) }
              .reject { |b| b.nil? }
              .select { |nbox| box.dominance > nbox.dominance }            
          end
          
          # Give a list of superiors
          def superiors box
            Box::NÄHE.map{ |b| box.send(b) }
              .reject { |b| b.nil? }
              .select { |nbox| box.dominance < nbox.dominance }            
          end

          # return all boxes with the proscribed dominance
          def boxes_of_dominance dom
            @layout.map{ |name, box| box }.select{ |box| box.dominance == dom }
          end
          
          def backlink_boxes
            @layout.each{ |name, box|
              box.bottom_box.top_box = box unless box.bottom_box.nil?
              box.right_box.left_box = box unless box.right_box.nil?
            }
            unlink_disabled_boxes
          end

          def unlink_disabled_boxes
            @layout.map{ |name, box| box }
              .reject{ |box| box.enabled? }
              .each{ |box|
              box.top_box.bottom_box = box.bottom_box
              box.bottom_box.top_box = box.top_box
              box.left_box.right_box = box.right_box
              box.right_box.left_box = box.left_box
            }
          end
        end
      end
    end
      
    module Mapper
      FX_CHART_RULER_NAMES = { x: { top: :top_ruler, bottom: :bottom_ruler },
                               y: { left: :left_ruler, right: :right_ruler }}
      def fx_chart name = nil,
                   ii: 0,
                   pos: Enhancement.stack.last,
                   reuse: nil,
                   &block
        Enhancement.stack << (os =
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
        
        os.op[0] = OpenStruct.new(:parent => :required,
                                   :target => nil,
                                   :selector => 0,
                                   :opts => FRAME_NORMAL,
                                   :x => 0,
                                   :y => 0,
                                   :width => 0,
                                   :height => 0)

        dsl = OpenStruct.new os: os
        
        # Initializers for the underlying 
        def dsl.target var; os.op[os.ii].target = var; end
        def dsl.selector var; os.op[os.ii].selector = var; end
        def dsl.opts var; os.op[os.ii].opts = var; end
        def dsl.x var; os.op[os.ii].x = var; end
        def dsl.y var; os.op[os.ii].y = var; end
        def dsl.width var; os.op[os.ii].width = var; end
        def dsl.height var; os.op[os.ii].height = var; end
        
        # Chart specific
        def dsl.type var; os.type = var; end
        
        def dsl.axis ax, placement=nil, **kv
          placement ||= (ax == :x) ? :bottom : ((ax == :y) ? :left : :error_axis)
          os.axial[FX_CHART_RULER_NAMES[ax][placement]] = OpenStruct.new(**(kv.merge({placement: placement})))
        end
        
        def dsl.data *dat; os.data = dat; end        
        def dsl.series ser; os.series = ser; end
        def dsl.domain a, b; os.domain = [a, b]; end
        def dsl.range a, b; os.range = [a, b]; end        
        def dsl.background **kv; kv.each{ |k,v| os.background[k] = v }; end
        def dsl.caption **kv; kv.each{ |k,v| os.caption[k] = v }; end
        def dsl.title **kv; os.title = OpenStruct.new **kv; end
        
        # What will be executed after FXCanvas is created.
        def dsl.instance aname=nil, &block
          os.instance_name = aname
          os.instance_block ||= []
          os.instance_block << [aname, block]
        end
        
        # Internal use only.
        def chart_instance os, &block
          os.instance_name = nil
          os.instance_block ||= []
          os.instance_block << [nil, block]
          return os
        end
        
        dsl.instance_eval &block
        
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
        return Enhancement.stack.last
      end
    end
  end
end

