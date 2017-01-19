#!/usr/bin/env ruby
require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper

fx_app :app do
  app_name "DataTarget"
  vendor_name "Example"

  fx_data_target (:texty) {
    value "Some initial data"
  }
  
  fx_main_window(:main) {
    title "Hello"
    opts DECOR_ALL

    fx_text {
      target refc(:texty)
    }
    
    fx_button {
      text "&See ya"
      target refc(:texty)
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

# alias for fox_component is fxc
fox_component :app do |app|
  app.launch
end
