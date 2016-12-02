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
          #def initialize
          #  super application,
          #        self.class.app_title,
          #        width: self.class.win_width,
          #        height: self.class.win_height
          #end
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
        @compusure = block
      end
      
      def _compose &block #DSL
        @compusure = block
        
        def title t
          @app_title = t
        end
        
        def width w
          @win_width = w
        end
        
        def height h
          @win_height = h
        end

        def show s
          @win_show = s
        end
        
        instance_eval &block 
      end
      
      # TODO: Metaprogramming to dry this up!!!
      def app_title;  instance_variable_get :@app_title;  end
      def win_width;  instance_variable_get :@win_width;  end
      def win_height; instance_variable_get :@win_height; end
      def win_show;   instance_variable_get :@win_show;   end
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
