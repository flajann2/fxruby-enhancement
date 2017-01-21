module Fox
  module Enhancement
    module Mapper
      def fx_chart name = nil, ii: 0, pos: Enhancement.stack.last, reuse: nil, &block
        Enhancement.stack << (@os = os = OpenStruct.new(klass: FXCanvas, op: [], ii: ii, fx: nil, kinder: [], inst: nil, instance_result: nil, reusable: reuse))
        Enhancement.components[name] = os unless name.nil?
        unless pos.nil?
          pos.kinder << os 
        else
          Enhancement.base = os
        end
        
        
        @os.op[0] = OpenStruct.new({:parent => :required,
                                    :target => nil,
                                    :selector => 0,
                                    :opts => FRAME_NORMAL,
                                    :x => 0,
                                    :y => 0,
                                    :width => 0,
                                    :height => 0})
        
        def parent var; @os.op[@os.ii].parent = var; end       
        def target var; @os.op[@os.ii].target = var; end
        def selector var; @os.op[@os.ii].selector = var; end
        def opts var; @os.op[@os.ii].opts = var; end
        def x var; @os.op[@os.ii].x = var; end
        def y var; @os.op[@os.ii].y = var; end
        def width var; @os.op[@os.ii].width = var; end
        def height var; @os.op[@os.ii].height = var; end
        
        def instance a=nil, &block
          @os.instance_name = a
          @os.instance_block = block
        end
        
        self.instance_eval &block
        
        os.fx = ->(){
          FXCanvas.new(*([pos.inst] + os.op[os.ii].to_h.values[1..-1]
                                      .map{ |v| (v.is_a?(OpenStruct)
                                                 ? v.inst
                                                 : v)
                         } ))
        }
        
        Enhancement.stack.pop                                                  
        @os = Enhancement.stack.last
        os
      end
    end
  end
end

