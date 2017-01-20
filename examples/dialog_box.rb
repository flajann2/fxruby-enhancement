#!/usr/bin/env ruby
require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper

fx_app :app do
  app_name "Dialog Box"
  vendor_name "Example"

  fx_main_window(:main) {
    title "Dialog Box Example"
    opts DECOR_ALL

    fx_button {
      text "&See Ya!"
      selector FXApp::ID_QUIT
      target refc(:app)
    }
    
    fx_button {
      text "&See Ya!"
      selector FXApp::ID_QUIT
      target refc(:app)
    }

    instance { |w|
      w.show PLACEMENT_SCREEN
    }
  }
end

# alias for fox_component is fxc
fox_component :app do |app|
  app.launch
end
