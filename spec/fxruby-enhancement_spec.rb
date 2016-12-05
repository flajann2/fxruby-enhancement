require_relative 'spec_helper'

describe String do
  it "supports snaking on strings" do
    s = "FXToolBar"
    expect(s.snake).to eq("fx_tool_bar")
  end
end

describe Symbol do
  it "supports snaking on symbols" do
    s = :FXToolBar
    expect(s.snake).to eq(:fx_tool_bar)
  end
end

include Fox
include Fox::Enhancement::Mapper

describe "DSL" do
  before :all do
    @app = fx_app :foobase do
      app_name "Foo Test"
      vendor_name "RubyNEAT Spinoff tech"
            
      @osmw = fx_main_window :main do
        title "test window"
        width 700
        height 300
        instance :foo_instance do |mw|
          mw.vSpacing = 2
          mw.show PLACEMENT_CURSOR
        end        
      end
      
      instance :app_startup do |app|
        :mission_accomplished
      end      
    end
    @app.create_fox_components
    @app.instance_final_activate
    @app.activate
  end
  
  it "allows creation of the FXApp and one window" do
    expect(Fox::Enhancement.base).to_not be_nil
    expect(Fox::Enhancement.base.klass).to eq Fox::FXApp
    @app.run_application
    expect(@app.instance_result).to eq(:mission_accomplished)
  end

  it "adds the components to the internal registry" do
    expect(fox_get_instance(:main).class).to eq(Fox::FXMainWindow)
  end
end
