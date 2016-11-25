=begin rdoc
==API Mapper for FXRuby
Indeed, the FXRuby library has direct
C++ interface calls, which requires parameters
that cannot be directly introspected, so we
provide "hints" for those cases.
=end

module Fox
  module Enhancement
    module Mapper
      class << self
        def fox_classes
          Fox.constants.select { |k|
            Fox.const_get(k).instance_of? Class
          }
        end

        def fox_initialize_parms
          fox_classes.map { |klass|
            [klass, Fox.const_get(klass)
                .instance_method(:initialize)
                .parameters
                .map{ |typ, nam|
               unless typ == :rest
                 [typ, nam]
               else
                 [:rest,
                  parm_hints(klass).map{ |parm| [:req, parm] }
                 ]
               end
             }
            ]
          }
        end
        
        HINTS = {
        }
        
        def parm_hints klass
          HINTS[klass]
        end        
      end
    end
  end
end
