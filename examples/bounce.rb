#!/usr/bin/env ruby
# frozen_string_literal: true
# rubocop:disable all

require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper

ANIMATION_TIME = 20

# Handles the "physics" of the ball.
class Ball
  attr_reader :color
  attr_reader :center
  attr_reader :radius
  attr_reader :dir
  attr_reader :x, :y
  attr_reader :w, :h
  attr_accessor :worldWidth
  attr_accessor :worldHeight

  def initialize(r)
    @radius = r
    @w = 2 * @radius
    @h = 2 * @radius
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
    dc.fillArc(x, y, w, h, 0, 64 * 90)
    dc.fillArc(x, y, w, h, 64 * 90, 64 * 180)
    dc.fillArc(x, y, w, h, 64 * 180, 64 * 270)
    dc.fillArc(x, y, w, h, 64 * 270, 64 * 360)
  end

  def bounce_x
    @dir.x = -@dir.x
  end

  def bounce_y
    @dir.y = -@dir.y
  end

  def collision_y?
    (y < 0 && dir.y < 0) || (y + h > worldHeight && dir.y > 0)
  end

  def collision_x?
    (x < 0 && dir.x < 0) || (x + w > worldWidth && dir.x > 0)
  end

  def setWorldSize(ww, wh)
    @worldWidth = ww
    @worldHeight = wh
  end

  def move(units)
    dx = dir.x * units
    dy = dir.y * units
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
  app_name 'Bounce'
  vendor_name 'Example'

  fx_main_window(:bounce_window) do
    title 'Bounce Demo'
    opts DECOR_ALL
    width 400
    height 300

    as (:app) do
      fx_image(:back_buffer) { opts IMAGE_KEEP }
    end

    instance do |w|
      def w.ball
        @ball ||= Ball.new(20)
      end

      def w.drawScene(drawable)
        FXDCWindow.new(drawable) do |dc|
          dc.setForeground(FXRGB(255, 255, 255))
          dc.fillRectangle(0, 0, drawable.width, drawable.height)
          ball.draw(dc)
        end
      end

      def w.updateCanvas
        ball.move(10)
        drawScene(ref(:back_buffer))
        ref(:canvas).update
      end

      #
      # Handle timeout events
      #
      def w.onTimeout(_sender, _sel, _ptr)
        # Move the ball and re-draw the scene
        updateCanvas

        # Re-register the timeout
        ref(:app)
          .addTimeout(ANIMATION_TIME,
                      ref(:bounce_window)
                        .method(:onTimeout))
        # Done
        1
      end

      w.show PLACEMENT_SCREEN
      ref(:app).addTimeout(ANIMATION_TIME, w.method(:onTimeout))
    end

    fx_canvas(:canvas) do
      opts LAYOUT_FILL_X | LAYOUT_FILL_Y

      instance do |c|
        c.sel_paint do |sender, _sel, event|
          FXDCWindow.new(sender, event) do |dc|
            dc.drawImage(ref(:back_buffer), 0, 0)
          end
        end

        c.sel_configure do |sender, _sel, _event|
          bb = ref(:back_buffer)
          bb.create unless bb.created?
          bb.resize(sender.width, sender.height)
          ref(:bounce_window) do |bw|
            bw.ball.setWorldSize(sender.width, sender.height)
            bw.drawScene(bb)
          end
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  # alias for fox_component is fxc
  fox_component :app, &:launch
end
