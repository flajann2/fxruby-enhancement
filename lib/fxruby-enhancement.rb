require 'fox16'

module Fox
  
  # include this in your top class objects.
  module Enhancement
    def self.included(klass)
      klass.extend ClassMethods
    end

    # Module-level
    class << self
      attr_accessor :application
      
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
  end 
end
