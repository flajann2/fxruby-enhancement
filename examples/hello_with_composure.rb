#!/usr/bin/env ruby
require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper

fx_app :app do
  app_name "Hello"
  vendor_name "Example"
end

class MainWindow < EFXMainWindow
  compose :main_window {    
    title "Hello"
    opts DECOR_ALL
        
    fx_button {
      text "&Hello, World"
      selector FXApp::ID_QUIT
      
      instance { |b|
        b.target = ref(:app)
      }
    }    
  }
  
  def show
    super PLACEMENT_SCREEN
  end
end

# alias for fox_component is fxc
fox_component :app do |app|
  app.launch do
  end
end
