require 'fox16'

module Fox
  
  # include this in your top class objects.
  module Enhancement
    class << self
      attr_accessor :app
      
      def app_set name, vendor
        @app = FXApp.new(name, vendor)
      end

      def run
        @app.run
      end
      
    end
  end
  
end
