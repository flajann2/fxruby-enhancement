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
    def app_activate
      Enhancement.app_activate
    end

    def application
      Enhancement.application
    end
    
    def create
      super
      show self.class.win_show
    end
    
    module Mapper
      def fox_get_component name
        Enhancement.components[name]
      end

      def fox_get_instance name
        fox_get_component(name).inst
      end
    end
  end
end
