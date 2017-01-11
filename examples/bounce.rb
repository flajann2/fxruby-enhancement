#!/usr/bin/env ruby
require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper

ANIMATION_TIME = 20

class Ball
  attr_reader :color
  attr_reader :center
  attr_reader :radius
  attr_reader :dir
  attr_reader :x, :y
  attr_reader :w, :h
  attr_accessor :worldWidth
  attr_accessor :worldHeight

  
  def initialize r
    @radius = r
    @w = 2*@radius
    @h = 2*@radius
    @center = FXPoint.new(50, 50)
    @x = @center.x - @radius
    @y = @center.y - @radius
    @color = FXRGB(255, 0, 0) # red
    @dir = FXPoint.new(-1, -1)
    setWorldSize(1000, 1000)
  end
  
  # Draw the ball into this device context
  def draw(dc)
    dc.setForeground(color)
    dc.fillArc(x, y, w, h, 0, 64*90)
    dc.fillArc(x, y, w, h, 64*90, 64*180)
    dc.fillArc(x, y, w, h, 64*180, 64*270)
    dc.fillArc(x, y, w, h, 64*270, 64*360)
  end

  def bounce_x
    @dir.x=-@dir.x
  end

  def bounce_y
    @dir.y=-@dir.y
  end

  def collision_y?
    (y<0 && dir.y<0) || (y+h>worldHeight && dir.y>0)
  end

  def collision_x?
    (x<0 && dir.x<0) || (x+w>worldWidth && dir.x>0)
  end

  def setWorldSize(ww, wh)
    @worldWidth = ww
    @worldHeight = wh
  end
  
  def move(units)
    dx = dir.x*units
    dy = dir.y*units
    center.x += dx
    center.y += dy
    @x += dx
    @y += dy
    if collision_x?
      bounce_x
      move(units)
    end
    if collision_y?
      bounce_y
      move(units)
    end
  end
end

fx_app :app do
  app_name "Bounce"
  vendor_name "Example"

  fx_image(:back_buffer) { opts IMAGE_KEEP }
  
  fx_main_window(:bounce_window) {
    title "Bounce Demo"
    opts DECOR_ALL
    width 400
    height 300
    
    instance { |w|
      def w.ball
        @ball ||= Ball.new(20)
      end
      
      def w.drawScene(drawable)
        FXDCWindow.new(drawable) { |dc|
          dc.setForeground(FXRGB(255, 255, 255))
          dc.fillRectangle(0, 0, drawable.width, drawable.height)
          ball.draw(dc)
        }
      end
      
      def w.updateCanvas
        ball.move(10)
        drawScene(ref(:back_buffer))
        ref(:canvas).update
      end
      
      #
      # Handle timeout events
      #
      def w.onTimeout(sender, sel, ptr)
        # Move the ball and re-draw the scene
        updateCanvas
        
        # Re-register the timeout
        ref(:app).addTimeout(ANIMATION_TIME, ref(:bounce_window).method(:onTimeout))
        
        # Done
        return 1
      end
      
      w.show PLACEMENT_SCREEN
      ref(:app).addTimeout(ANIMATION_TIME, w.method(:onTimeout))
    }
    
    fx_canvas(:canvas) {
      opts LAYOUT_FILL_X|LAYOUT_FILL_Y
      
      instance { |c|
        c.sel_paint { |sender, sel, event|
          FXDCWindow.new(sender, event) { |dc|
            dc.drawImage(ref(:back_buffer), 0, 0)
          }
        }

        c.sel_configure{ |sender, sel, event|
          bb = ref(:back_buffer)
          bb.create unless bb.created?
          bb.resize(sender.width, sender.height)
          ref(:bounce_window) do |bw|
            bw.ball.setWorldSize(sender.width, sender.height)
            bw.drawScene(bb)
          end
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
