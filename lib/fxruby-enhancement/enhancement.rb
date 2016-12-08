module Fox 
  # include this in your top class objects.
  # If for a module, you want to extend, rather
  # than include FIXME: later we will clean
  # this up.
  module Enhancement
    @stack = []
    @base = nil
    @components = {}
    SPECIAL = [:FXApp,
               :FXColorItem,
               :FXRegion,
               :FXRectangle,
               :FXGradient,
               :FXEvent,
               :FXFileStream,
               :FXExtentd]
    INITFORCE = { FXMenuBar: 1 }
    
    # Module-level    
    class << self      
      attr_accessor :application
      attr_accessor :stack, :base, :components
      
      def included(klass)
        klass.extend ClassMethods
        klass.class_eval do
        end
      end

      def reset_components
        @components = {}
      end      
    end

    # class level
    module ClassMethods
      def compose &block #DSL
        @composure = block
      end      
    end

    # instance level
    # Add it here.
    
    module Mapper
      # Find the referenced component's instance
      def ref sym
        raise "No reference for #{sym} found" if Enhancement.components[sym].nil?
        raise "No instance for #{sym} allocated" if Enhancement.components[sym].inst.nil?        
        Enhancement.components[sym].inst
      end
      
      # Find the referenced component's wrapper object
      def refc sym
        raise "No reference component for #{sym} found" if Enhancement.components[sym].nil?
        Enhancement.components[sym]
      end

      def fox_get_component name, &block
        if block_given?
          block.(Enhancement.components[name])
        else
          Enhancement.components[name]
        end
      end

      def fox_get_instance name, &block
        if block_given?
          block.(fox_get_component(name).inst)
        else
          fox_get_component(name).inst
        end
      end
    end
  end
end
