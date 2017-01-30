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
      text "Show me a Dialog"
      instance { |b|
        b.sel_command {
          refc(:dialog).starten
        }
      }
    }
    
    fx_button {
      text "&See Ya!"
      selector FXApp::ID_QUIT
      target refc(:app)
    }
    instance { |w| w.show PLACEMENT_SCREEN }

    # Since this is defined in the context
    # of the main window, it will hover over
    # it.
    fx_dialog_box(:dialog, reuse: true) {
      title "I am a Dialog!"
      opts DECOR_ALL
      
      fx_button {
        text "&It Works!"
        instance { |dia|
          dia.sel_command {
            refc(:dialog).stoppen
          }
        }
      }      
      instance { |dia| dia.show PLACEMENT_OWNER  }
    }
  }
end

# alias for fox_component is fxc
fox_component :app do |app|
  app.launch
end
