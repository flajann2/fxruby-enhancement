module Fox 
  # include this in your top class objects.
  # If for a module, you want to extend, rather
  # than include FIXME: later we will clean
  # this up.
  module Enhancement
    @stack = []
    @base = nil
    
    # Module-level
    class << self
      attr_accessor :application
      attr_accessor :stack, :base
      
      def included(klass)
        klass.extend ClassMethods
        klass.class_eval do
        end
      end
      
      def app_set name, vendor
        @application = FXApp.new(name, vendor)
      end
      
      def app_activate
        @application.create
        @application.run
      end
    end

    # class level
    module ClassMethods
      def compose &block #DSL
        @composure = block
      end      
    end


    # instance level    
    def app_set name, vendor
      Enhancement.app_set name, vendor
    end

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
  end 
end
