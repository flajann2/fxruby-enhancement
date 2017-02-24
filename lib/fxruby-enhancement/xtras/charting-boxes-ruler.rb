module Fox
  module Enhancement
    module Xtras
      module Charting        
        class Ruler < Box
          attr_accessor :rconf
          
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
          end
        end
      end
    end
  end
end

