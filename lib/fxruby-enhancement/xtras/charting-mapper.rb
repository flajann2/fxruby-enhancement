module Fox
  module Enhancement
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
        
        os.op[0] = OpenStruct.new(parent: :required,
                                  target:  nil,
                                  selector: 0,
                                  opts: FRAME_NORMAL,
                                  x: 0,
                                  y: 0,
                                  width: 0,
                                  height: 0,
                                  axial: {})

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
        def dsl.domain a, b; os.domain = (a...b); end
        def dsl.range a, b; os.range = (a...b); end        
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

