# coding: utf-8

module Fox
  module Enhancement
    module Xtras
      module Charting
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
          end
          
          def draw_dc &block
            @buffer.starten if @buffer.inst.nil?
            FXDCWindow.new(@buffer.inst) { |dc| block.(dc) }
          end
          
          def update_chart
            draw_dc { |dc|
              dc.setForeground white
              dc.fillRectangle 0, 0, width, height
              dc.drawImage @buffer.inst, 0, 0
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

