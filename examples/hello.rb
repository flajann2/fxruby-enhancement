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

# alias for fox_component is fxc
fox_component :app do |app|
  app.launch
end

#application = FXApp.new("Hello", "FoxTest")
#main = FXMainWindow.new(application, "Hello", nil, nil, DECOR_ALL)
#FXButton.new(main, "&Hello, World!", nil, application, FXApp::ID_QUIT)
#application.create()
#main.show(PLACEMENT_SCREEN)
#application.run()
