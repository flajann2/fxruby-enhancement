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
                coord = 1.0 - coord if orientation == :vertical
                dc.drawLine *compute_tick_coords(coord, major)
              }
              
              t.tick_label_lambda = ->(coord, label) {
                coord = 1.0 - coord if orientation == :vertical
                xx, yy = compute_label_coords coord
                dc.font = @tfont
                dc.drawText xx, yy, label
              }
              
            end.compute_ticks if enabled
            draw_caption dc
          end

          def initialize chart, **kv
            super
            @rconf = kv[:axial][@name]
            @enabled = ! @rconf.nil?
            @dominance = 2            
            configure_ruler unless @rconf.nil?
          end

          def calculate_dimensions
            self.width  = (orientation == :vertical)   ? ruler_height : 0
            self.height = (orientation == :horizontal) ? ruler_height : 0
          end
          
          private
          
          def draw_caption dc
            unless rconf.name.nil?
              tx_length = cfont.getTextWidth rconf.name
              
              xx = case orientation
                   when :horizontal
                     x + width / 2 - tx_length / 2
                   when :vertical
                     x + @rc_margin + @rc_height
                   else
                     raise "Unknown orientation #{orientation}"
                   end
              
              yy = case orientation
                   when :horizontal
                     y + @tm_height + 2*@tml_margin + @tml_height + @rc_margin
                   when :vertical
                     y + height / 2 + tx_length / 2
                   else
                     raise "Unknown orientation #{orientation}"
                   end
              dc.font = cfont
              dc.foreground = rconf.color
              dc.drawText xx, yy, rconf.name
            end
          end
          
          def compute_label_coords coord
            x1, y1, x2, y2 = compute_tick_coords coord
            if orientation == :vertical
              [x1 - @tm_height - @tml_margin, y1]
            elsif orientation == :horizontal
              [x1, y1 + @tm_height + @tml_margin + @tfont.realFontAscent]
            else
              raise "Unknown orientation #{orientation}"
            end
          end

          # [x1, y1] is always flush to the edge nearest chart!
          def compute_tick_coords coord, major = false
            tick_length = major ? @tm_height : @tm_minor_height
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
            return [x1, y1, x2, y2]
          end        
          
          def configure_ruler
            configure_ruler_fonts
            configure_margins
            configure_tickmark_height
            configure_tickmark_labels
            configure_ruler_caption
          end

          def configure_ruler_fonts
            @font_angle = if orientation == :vertical
                            90
                          else
                            0
                          end
            @cfont = load_font((font_desc(**rconf[:cfont]) || font_desc(font: 'arial', size: 10)), @font_angle)
            @tfont = load_font((font_desc(**rconf[:tfont]) || font_desc(font: 'arial', size: 10)), @font_angle)
          end

          def load_font font, angle=0
            f = FXFont.new ref(:app), font
            f.smart_create angle
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
            @tml_height = tfont.realFontHeight
          end

          def configure_ruler_caption
            @rc_height = cfont.realFontHeight
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
          def ruler_height
            if enabled?
              2 * @rc_margin + @rc_height + 2 * @tml_margin + @tml_height + @tm_height
            else
              0
            end
          end
        end
      end
    end
  end
end
