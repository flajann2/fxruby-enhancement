#!/usr/bin/env ruby

require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper

fx_app :app do
  app_name "Hello"
  vendor_name "Example"

  fx_main_window(:main) {
    title "Hello"
    opts DECOR_ALL

    fx_button {
      text "&Hello, World"
      selector FXApp::ID_QUIT
      
      instance { |b|
        b.target = ref(:app)
      }
    }

    instance { |w|
      w.show PLACEMENT_SCREEN
    }
  }
end

fox_component :app do |app|
  app.launch
end
