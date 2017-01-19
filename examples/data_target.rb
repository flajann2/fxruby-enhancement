#!/usr/bin/env ruby
require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper

fx_app :app do
  app_name "DataTarget"
  vendor_name "Example"

  fx_data_target (:textx) { value "x marks the spot!"  }
  fx_data_target (:texty) { value "y do it?"  }
  
  fx_main_window(:main) {
    title "fx_data_target example"
    opts DECOR_ALL
    width 300
    x 100
    y 200

    fx_text_field (:text_1) {
      ncols 40
      target refc(:textx)
      selector FXDataTarget::ID_VALUE
    }
    fx_text_field (:text_2) {
      ncols 40
      target refc(:textx)
      selector FXDataTarget::ID_VALUE
    }
    fx_text (:text_3) {
      opts LAYOUT_FILL_X
      target refc(:texty)
      selector FXDataTarget::ID_VALUE
    }
    fx_text (:text_4) {
      opts LAYOUT_FILL_X
      target refc(:texty)
      selector FXDataTarget::ID_VALUE
    }
    fx_button {
      text "&See ya!"
      selector FXApp::ID_QUIT
      opts BUTTON_NORMAL|LAYOUT_CENTER_X
      
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
