# coding: utf-8
module Fox
  module Enhancement
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
                                             axis: OpenStruct.new, #TODO: name changed to protect the innocent
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

        #TODO: Subtle bug in Ruby 2.4.0 tripped over here with
        #TODO: the name of this funcion being the same as the
        #TODO: initialized variable in the OS, so I had to make
        #TODO: them different, hence the "axis".
        def axis ax, **kv
          ap @os.axis[ax] = OpenStruct.new(**kv)
        end

        def background **kv; kv.each{ |k,v| @os.background[k] = v }; end

        # What will be executed after FXCanvas is created.
        def instance a=nil, &block
          @os.instance_name = a
          @os.instance_block ||= []
          @os.instance_block << [a, block]
        end
        
        self.instance_eval &block
        
        os.fx = ->(){
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
