#!/usr/bin/env ruby
# coding: utf-8
require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper
include RGB

CHART_UPDATE_TIME = 100

fx_app :app do
  app_name "Chart"
  vendor_name "Example"
  
  fx_main_window(:chart_window) {
    title "Chart Demo"
    opts DECOR_ALL
    width 400
    height 300
    
    instance { |w|           
      #
      # Handle timeout events
      #
      def w.onTimeout(sender, sel, ptr)

        ref(:chart).update_chart
        
        # Re-register the timeout
        ref(:app).addTimeout(CHART_UPDATE_TIME, ref(:chart_window).method(:onTimeout))
        
        # Done
        return 1
      end
      
      w.show PLACEMENT_SCREEN
      ref(:app).addTimeout(CHART_UPDATE_TIME, w.method(:onTimeout))
    }
    
    fx_chart(:chart) {
      opts LAYOUT_FILL_X|LAYOUT_FILL_Y
      type :cartesian
      background color: sea_green1, grid: true, grid_color: blue
      axis :x, :bottom, type: :linear, color: red, name: "Time"
      axis :y, :left,   type: :linear, color: blue, name: "Price"

      caption text: "This illustrates how easy the chart is to use."
      title   text: "Demo chart"
      
      data [1, 22.1, 34.2, 11],
           [2, 23.4, 25.0, 14],
           [3, 25.2, 35.2, 12],
           [4, 21.9, 63.3, 11],
           [5, 11.4, 50.1, 20]
      series({ 0 => {
                 label: 'x-axis',
                 type: :range },
               1 => {
                 label: 'Germany',
                 type: :data,
                 color: :yellow,
                 thickness: 3 },
               2 => {
                 label: 'Poland',
                 type: :data,
                 color: :blue,
                 thickness: 1 },
               3 => {
                 label: 'Östereich',
                 type: :data,
                 color: :green,
                 thickness: 2 }})
      domain 0, 5
      range 0.0, 50.0
      
      instance { |c|
      }
    }
  }
end

if __FILE__ == $0
  # alias for fox_component is fxc
  fox_component :app do |app|
    app.launch
  end
end
