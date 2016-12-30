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
      
      # queues for messages objects coming from and going to other threads.
      attr_accessor :ingress, :egress
      
      def included(klass)
        @ingress ||= QDing.new
        @egress  ||= QDing.new
        klass.extend ClassMethods
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

      # Wrapper component
      def fox_component name, &block
        if block_given?
          block.(Enhancement.components[name])
        else
          Enhancement.components[name]
        end
      end
      alias_method :fxc, :fox_component

      # Actual FX Object instance
      def fox_instance name, &block
        if block_given?
          block.(fox_component(name).inst)
        else
          fox_component(name).inst
        end
      end
      alias_method :fxi, :fox_instance

    end
  end
end
