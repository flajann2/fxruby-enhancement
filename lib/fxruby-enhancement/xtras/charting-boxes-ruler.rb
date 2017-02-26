module Fox
  module Enhancement
    module Xtras
      module Charting
        
        # This handles rules of all orientations and positionings.
        class Ruler < Box
          attr_accessor :rconf, :cfont, :tfont
          
          def render dc
            super
            range = case orientation
                    when :horizontal
                      @chart.x_range
                    when :vertical
                      @chart.y_range
                    else raise "unknown orientation :#{orientation}"
                    end
            
            # coord is normalized, 0 .. 1
            Ticks.new(range) do |t|
              dc.foreground = @rconf.color || black
              
              t.tick_lambda = ->(coord, value, major) {
                tick_length = (orientation == :horizontal ? height : width) / (major ? 2 : 4)
                
                x1 = if orientation == :horizontal
                       x + width * coord  
                     elsif orientation == :vertical
                       if placement == :left
                         x + width
                       elsif placement == :right
                         x
                       else
                         raise "unknown placement :#{placement}"
                       end
                     else
                       raise "unknown orientation :#{orientation}"
                     end
                
                y1 = if orientation == :horizontal
                       if placement == :top
                         y + height
                       elsif placement == :bottom
                         y
                       else
                         raise "unknown placement :#{placement}"
                       end
                     elsif orientation == :vertical
                       y + height * coord
                     else
                       raise "unknown orientation :#{orientation}"                       
                     end
                
                x2 = if orientation == :horizontal
                       x1
                     elsif orientation == :vertical
                       if placement == :left
                         x1 - tick_length
                       elsif placement == :right
                         x1 + tick_length
                       else
                         raise "unknown placement :#{placement}"
                       end
                     else
                       raise "unknown orientation :#{orientation}"                       
                     end

                y2 = if orientation == :horizontal
                       if placement == :top
                         y1 - tick_length
                       elsif placement == :bottom
                         y1 + tick_length
                       else
                         raise "unknown placement :#{placement}"
                       end
                     elsif orientation == :vertical
                       y1
                     else
                       raise "unknown orientation :#{orientation}"                       
                     end
                dc.drawLine x1, y1, x2, y2
              }
              
              t.tick_label_lambda = ->(coord, label) {}
            end.compute_ticks if enabled           
          end
          
          def initialize chart, **kv
            super
            @rconf = kv[:axial][@name]
            @enabled = ! @rconf.nil?
            @dominance = 2
            
            configure_ruler unless @rconf.nil?
          end

          # The "height" of the ruler (not the length)
          # is determined according to the following formula:
          ## R = 2a + C + 2b + L + T
          ## where:
          ### R - ruler height
          ### a - ruler caption box margin
          ### C - ruler caption box height
          ### b - tickmarks label box margin
          ### L - tickmarks label height
          ### T - tickmarks height
          # Note that this assumes a horizontal orientation. Since
          # in the vertical orientation the text will be so-oriented,
          # "height" would actually be visually the width.
          def calculate_dimensions
            self.width  = (orientation == :vertical)   ? ruler_height : 0
            self.height = (orientation == :horizontal) ? ruler_height : 0
          end
          
          private
          
          def configure_ruler
            configure_ruler_fonts
            configure_margins
            configure_tickmark_height
            configure_tickmark_labels
            configure_ruler_caption
          end

          def configure_ruler_fonts
            @cfont = load_font( rconf[:cfont] || "arial,120" )
            @tfont = load_font( rconf[:tfont] || "arial,120" )
          end

          def load_font font
            f = FXFont.new ref(:app), font
            f.create
            return f
          end

          def configure_margins
            @rc_margin = rconf[:rc_margin] || 2
            @tml_margin = rconf[:tml_margin] || 3
          end

          def configure_tickmark_height
            @tm_height = rconf[:tm_height] || 12
            @tm_minor_height = rconf[:tm_minor_height] || (@tm_height / (rconf[:tm_minor_divisor] || 2))
          end

          def configure_tickmark_labels
            @tml_height = @tfont.getTextHeight "012345679.0-+"
          end

          def configure_ruler_caption
            @rc_height = @cfont.getTextHeight rconf[:name]
          end

          def ruler_height
            if enabled?
              2 * @rc_margin + @rc_height + 2 * @tml_margin + @tml_height + @tml_height
            else
              0
            end
          end
        end
      end
    end
  end
end
