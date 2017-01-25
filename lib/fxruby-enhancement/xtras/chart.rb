# coding: utf-8
module Fox
  module Enhancement
    module Xtras
      class Chart
        def initialize canvas
          @canvas = canvas
        end
        
        def draw(dc)
        end
      end
    end
    
    module Mapper
      def fx_chart name = nil, ii: 0, pos: Enhancement.stack.last, reuse: nil, &block
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
                                             axial: OpenStruct.new, #TODO: bug/ruby240 branch
                                             background: OpenStruct.new))
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
        end
        
        self.instance_eval &block
        
        os.fx = ->(){
          chart_instance (os) { |c|
            puts "**** chart_instance called ****"
            os.chart = Xtras::Chart.new c
          }
          
          FXCanvas.new(*([pos.inst] + os.op[os.ii].to_h.values[1..-1]
                                      .map{ |v| (v.is_a?(OpenStruct) ? v.inst : v)
                         } ))
        }
        
        Enhancement.stack.pop                                                  
        @os = Enhancement.stack.last
        return os
      end
    end
  end
end
