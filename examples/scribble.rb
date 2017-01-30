#!/usr/bin/env ruby
require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper

class ScribbleWindow < FXMainWindow

  def initialize(app)
    # Call base class initializer first
    super(app, "Scribble Application", :width => 800, :height => 600)

    # Construct a horizontal frame to hold the main window's contents
    @contents = FXHorizontalFrame.new(self,
      LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :padLeft => 0, :padRight => 0, :padTop => 0, :padBottom => 0)

    # Left pane contains the canvas
    ref(:canvas)Frame = FXVerticalFrame.new(@contents,
      FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT,
      :padLeft => 10, :padRight => 10, :padTop => 10, :padBottom => 10)

    # Place a label above the canvas
    FXLabel.new(ref(:canvas)Frame, "Canvas Frame", nil, JUSTIFY_CENTER_X|LAYOUT_FILL_X)

    # Horizontal divider line
    FXHorizontalSeparator.new(ref(:canvas)Frame, SEPARATOR_GROOVE|LAYOUT_FILL_X)

    # Drawing canvas
    ref(:canvas) = FXCanvas.new(ref(:canvas)Frame, :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT)
     ref(:canvas).connect(SEL_PAINT) do |sender, sel, event|
      FXDCWindow.new(ref(:canvas), event) do |dc|
        dc.foreground = ref(:canvas).backColor
        dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w, event.rect.h)
      end
    end
     ref(:canvas).connect(SEL_LEFTBUTTONPRESS) do
       ref(:canvas).grab
      @mouseDown = true
    end
     ref(:canvas).connect(SEL_MOTION) do |sender, sel, event|
      if @mouseDown
        # Get device context for the canvas
        dc = FXDCWindow.new(ref(:canvas))

        # Set the foreground color for drawing
        dc.foreground = @drawColor

        # Draw a line from the previous mouse coordinates to the current ones
        if @mirrorMode.value
          cW = ref(:canvas).width
          cH = ref(:canvas).height
          dc.drawLine(cW-event.last_x, event.last_y,
                      cW-event.win_x, event.win_y)
          dc.drawLine(event.last_x, cH-event.last_y,
                      event.win_x, cH-event.win_y)
          dc.drawLine(cW-event.last_x, cH-event.last_y,
                      cW-event.win_x, cH-event.win_y)
        end
        dc.drawLine(event.last_x, event.last_y, event.win_x, event.win_y)

        # We have drawn something, so now the canvas is dirty
        @dirty = true

        # Release the DC immediately
        dc.end
      end
    end
     ref(:canvas).connect(SEL_LEFTBUTTONRELEASE) do |sender, sel, event|
       ref(:canvas).ungrab
      if @mouseDown
        # Get device context for the canvas
        dc = FXDCWindow.new(ref(:canvas))

        # Set the foreground color for drawing
        dc.foreground = @drawColor

        # Draw a line from the previous mouse coordinates to the current ones
        dc.drawLine(event.last_x, event.last_y, event.win_x, event.win_y)

        # We have drawn something, so now the canvas is dirty
        @dirty = true

        # Mouse no longer down
        @mouseDown = false

        # Release this DC immediately
        dc.end
      end
    end

    # Right pane for the buttons
    @buttonFrame = FXVerticalFrame.new(@contents,
      FRAME_SUNKEN|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT,
      :padLeft => 10, :padRight => 10, :padTop => 10, :padBottom => 10)

    # Label above the buttons
    FXLabel.new(@buttonFrame, "Button Frame", nil, JUSTIFY_CENTER_X|LAYOUT_FILL_X)

    # Horizontal divider line
    FXHorizontalSeparator.new(@buttonFrame, SEPARATOR_RIDGE|LAYOUT_FILL_X)

    # Enable or disable mirror mode
    @mirrorMode = FXDataTarget.new(false)
    FXCheckButton.new(@buttonFrame, "Mirror", @mirrorMode, FXDataTarget::ID_VALUE, CHECKBUTTON_NORMAL|LAYOUT_FILL_X)

    # Button to clear the canvas
    clearButton = FXButton.new(@buttonFrame, "&Clear",
      :opts => FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT,
      :padLeft => 10, :padRight => 10, :padTop => 5, :padBottom => 5)
    clearButton.connect(SEL_COMMAND) do
      FXDCWindow.new(ref(:canvas)) do |dc|
        dc.foreground = ref(:canvas).backColor
        dc.fillRectangle(0, 0, ref(:canvas).width, ref(:canvas).height)
        @dirty = false
      end
    end
    clearButton.connect(SEL_UPDATE) do |sender, sel, ptr|
      # This procedure handles the update message sent by the Clear button
      # to its target. Every widget in FOX receives a message (SEL_UPDATE)
      # during idle processing, asking it to update itself. For example,
      # buttons could be enabled or disabled as the state of the application
      # changes.
      #
      # In this case, we'll disable the sender (the Clear button) when the
      # canvas has already been cleared (i.e. it's "clean"), and enable it when
      # it has been painted (i.e. it's "dirty").
      message = @dirty ? FXWindow::ID_ENABLE : FXWindow::ID_DISABLE
      sender.handle(self, MKUINT(message, SEL_COMMAND), nil)
    end

    # Exit button
    FXButton.new(@buttonFrame, "&Exit", nil, app, FXApp::ID_QUIT,
      FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT,
      :padLeft => 10, :padRight => 10, :padTop => 5, :padBottom => 5)

    # Initialize other member variables
    @drawColor = "red"
    @mouseDown = false
    @dirty = false
  end

  # Create and show the main window
  def create
    super                  # Create the windows
    show(PLACEMENT_SCREEN) # Make the main window appear
  end
end

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

      fx_veritcal_frame (:canvas_frame) {
        opts FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT
        pad_left 10
        pad_right 10
        pad_top 10
        pad_bottom 10
        
        fx_label {
          text "Canvas Frame"
          opts JUSTIFY_CENTER_X|LAYOUT_FILL_X
        }

        fx_horizontal_seperator { opts SEPARATOR_GROOVE|LAYOUT_FILL_X }
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
                  if @mirrorMode.value
                    cW = ref(:canvas).width
                    cH = ref(:canvas).height
                    dc.drawLine(cW-event.last_x, event.last_y,
                                cW-event.win_x, event.win_y)
                    dc.drawLine(event.last_x, cH-event.last_y,
                                event.win_x, cH-event.win_y)
                    dc.drawLine(cW-event.last_x, cH-event.last_y,
                                cW-event.win_x, cH-event.win_y)
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

        fx_horizontal_seperator {opts SEPARATOR_RIDGE|LAYOUT_FILL_X }
        as (:app) {
          fx_data_target (:mirror_mode) { value false }
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
          target FXApp::ID_QUIT
          opts FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT
          pad_left 10
          pad_right 10
          pad_top 5
          pad_bottom 5          
        }
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
