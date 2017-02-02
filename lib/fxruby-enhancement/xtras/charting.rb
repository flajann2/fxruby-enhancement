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
        class CBox
          include RGB
          
          # coordinate and dimensions of the box
          attr_accessor :x, :y, :width, :height
          
          # textual orientation :horizontal, :vertical
          attr_accessor :orientation

          # adjoining boxes and connection type
          # [other_box, :spring] oder [other_box, 24], etc
          attr_accessor :top_box, :bottom_box, :left_box, :right_box

          attr_accessor :enabled

          # always overide this the default simply renders a box
          def render dc
            dc.foreground = black
            dc.drawRectangle x, y, width, height
          end
          
          def enabled? ; enabled ; end
        end

        class Title < CBox
        end
        
        class Ruler < CBox
        end
        
        class TopRuler < Ruler
        end
        
        class BottomRuler < Ruler
        end
        
        class LeftRuler < Ruler
        end
        
        class RightRuler < Ruler
        end
        
        class Caption < CBox
        end

        class Legend < CBox
        end

        # main charting area.
        class Graph < CBox
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
            @layout = lyt = {title: Title.new,
                             top_ruler: TopRuler.new,
                             bottom_ruler: BottomRuler.new,
                             left_ruler: LeftRuler.new,
                             right_ruler: RightRuler.new,
                             caption: Caption.new,
                             legend: Legend.new,
                             graph: Graph.new}
            # bottom connections
            lyt[:title].bottom_box        = [lyt[:top_ruler], :spring]
            lyt[:top_ruler].bottom_box    = [lyt[:graph], 1]
            lyt[:graph].bottom_box        = [lyt[:bottom_ruler], 1]
            lyt[:bottom_ruler].bottom_box = [lyt[:caption], :spring]
            lyt[:left_ruler].right_box    = [lyt[:graph], 1]
            lyt[:graph].right_box         = [lyt[:right_ruler], 1]
            lyt[:right_ruler].right_box   = [lyt[:legend], :spring]
            backlink_boxes
          end

          def backlink_boxes
            @layout.each{ |name, box|
              box.bottom_box.first.top_box = [box, box.bottom_box.last] unless box.bottom_box.nil?
              box.right_box.first.left_box = [box, box.right_box.last] unless box.right_box.nil?
            }
          end

          # call inially and when there's an update
          def layout_boxes
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

