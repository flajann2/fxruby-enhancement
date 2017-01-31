#!/usr/bin/env ruby
# coding: utf-8
require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper

### debugging
TRACE_FILES = %w{
api-mapper.rb:1776-1845
enhancement.rb
scribble.rb
}

TFILES = TRACE_FILES.map{ |s| s.split(':').first }

set_trace_func proc { |event, file, line, id, binding, classname|
  base, srange = File.basename(file).split(':')
  stnum, endnum = srange.split('-') unless srange.nil?
  stnum  = srange.nil? ? nil : stnum.to_i
  endnum = srange.nil? && endnum.nil? ? nil : endnum.to_i
  if TFILES.member?(base) && (srange.nil? ||
                                  (endnum.nil? && line == stnum) ||
                                  (stnum <= line && line <= endnum))
    printf "%8s %s:%-2d %10s %8s %s\n",
           event,
           base,
           line,
           id,
           classname,
           binding.receiver
  end
}
### end debugging

fx_app :app do
  app_name "Scribble"
  vendor_name "Example"

  fx_main_window (:scribble_window) {
    title "Scribble Application"
    width 800
    height 600

    fx_horizontal_frame (:contents) {
      opts LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y
      pad_left 0
      pad_right 0
      pad_top 0
      pad_bottom 0

      fx_vertical_frame (:canvas_frame) {
        opts FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT
        pad_left 10
        pad_right 10
        pad_top 10
        pad_bottom 10
        
        fx_label {
          text "Canvas Frame"
          opts JUSTIFY_CENTER_X|LAYOUT_FILL_X
        }

        fx_horizontal_separator { opts SEPARATOR_GROOVE|LAYOUT_FILL_X }
        fx_canvas (:canvas) {
          opts LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT

          instance { |c|
            c.sel_paint { |sender, sel, event|
              FXDCWindow.new(ref(:canvas), event) do |dc|
                dc.foreground = ref(:canvas).backColor
                dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w, event.rect.h)
              end
            }

            c.sel_leftbuttonpress {
              ref(:canvas).grab
              @mouseDown = true
            }

            c.sel_motion { |sender, sel, event|
              if @mouseDown
                # Get device context for the canvas
                FXDCWindow.new(ref(:canvas)) { |dc|
                  # Set the foreground color for drawing
                  dc.foreground = @drawColor
                  
                  # Draw a line from the previous mouse coordinates to the current ones
                  if ref(:mirror_mode).value
                    cW = ref(:canvas).width
                    cH = ref(:canvas).height
                    dc.drawLine(cW-event.last_x, event.last_y, cW-event.win_x, event.win_y)
                    dc.drawLine(event.last_x, cH-event.last_y, event.win_x, cH-event.win_y)
                    dc.drawLine(cW-event.last_x, cH-event.last_y, cW-event.win_x, cH-event.win_y)
                  end
                  dc.drawLine(event.last_x, event.last_y, event.win_x, event.win_y)
                  
                  # We have drawn something, so now the canvas is dirty
                  @dirty = true
                }
              end
            }

            c.sel_leftbuttonrelease { |sender, sel, event|
              ref(:canvas).ungrab
              if @mouseDown
                # Get device context for the canvas
                FXDCWindow.new(ref(:canvas)) { |dc|                
                  # Set the foreground color for drawing
                  dc.foreground = @drawColor
                  
                  # Draw a line from the previous mouse coordinates to the current ones
                  dc.drawLine(event.last_x, event.last_y, event.win_x, event.win_y)
                  
                  # We have drawn something, so now the canvas is dirty
                  @dirty = true
                
                  # Mouse no longer down
                  @mouseDown = false
                }
              end
            }
          }
        }
      }
      
      fx_vertical_frame (:button_frame) {
        opts FRAME_SUNKEN|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT
        pad_left 10
        pad_right 10
        pad_top 10
        pad_bottom 10

        fx_label {
          text "Button Frame"
          opts JUSTIFY_CENTER_X|LAYOUT_FILL_X
        }

        fx_horizontal_separator {opts SEPARATOR_RIDGE|LAYOUT_FILL_X }

        as (:app) {
          fx_data_target (:mirror_mode) { value true }
        }
        
        fx_check_button {
          text "Mirror"
          target refc(:mirror_mode)
          selector FXDataTarget::ID_VALUE
          opts CHECKBUTTON_NORMAL|LAYOUT_FILL_X
        }

        fx_button (:clear_button) {
          text "&Clear"
          opts FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT
          pad_left 10
          pad_right 10
          pad_top 5
          pad_bottom 5

          instance { |b|
            b.sel_command {
              FXDCWindow.new(ref(:canvas)) do |dc|
                dc.foreground = ref(:canvas).backColor
                dc.fillRectangle(0, 0, ref(:canvas).width, ref(:canvas).height)
                @dirty = false
              end
            }

            b.sel_update { |sender, sel, ptr|
              message = @dirty ? FXWindow::ID_ENABLE : FXWindow::ID_DISABLE
              sender.handle(ref(:scribble_window), MKUINT(message, SEL_COMMAND), nil)
            }
          }
        }

        fx_button {
          text "&Exit"
          selector FXApp::ID_QUIT
          target refc(:app)
          opts FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT
          pad_left 10
          pad_right 10
          pad_top 5
          pad_bottom 5          
        }
      }
    }

    instance { |w|
      @drawColor = "red"
      @mouseDown = false
      @dirty = false
      w.show PLACEMENT_SCREEN
    }
  }
end

if __FILE__ == $0
  # alias for fox_component is fxc
  fox_component :app do |app|
    app.launch
  end
end
