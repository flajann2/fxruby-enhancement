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

describe "DSL" do
  include Fox
  include Fox::Enhancement::Mapper
  
  it "allows creation of the FXApp and one window" do
    app = fx_app :foobase do
      app_name "Foo Test"
      vendor_name "RubyNEAT Spinoff tech"
            
      fx_main_window :main do
        title "test window"
        width 500
        height 300
        instance :foo_instance do |mw|
          mw.vSpacing = 2
        end        
      end
      
      instance :app_startup do |app|
        :mission_accomplished
      end      
    end
    expect(Fox::Enhancement.base).to_not be_nil
    expect(Fox::Enhancement.base.klass).to eq Fox::FXApp
    app.create_fox_components
    app.instance_final_activate
    expect(app.instance_result).to eq(:mission_accomplished)
  end
end
