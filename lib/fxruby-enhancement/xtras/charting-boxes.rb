# coding: utf-8
module Fox
  module Enhancement
    module Xtras
      # Charting constructs. Note that the
      # rulers have built-in their own labeling, with orientation.
      module Charting        
        # Box area of drawing interest. This is
        # more virtual than actual, i.e. no clipping
        # is performed.
        class Box
          include RGB
          MAX_DOMINANCE = 3
          NÄHE = [:top_box, :bottom_box, :left_box, :right_box]

          # Name of this box -- we use this in some cases to avoid class polution
          attr_reader :name
          
          # coordinate and dimensions of the box
          attr_accessor :x, :y, :width, :height

          # hints on width and heigt, if meaningful, otherwise nil
          attr_accessor :hint_width, :hint_height
          
          # textual / apperance orientation :horizontal, :vertical, :none
          # placement :top, :bottom, :left, :right
          attr_accessor :orientation, :placement

          # adjoining boxes 
          attr_accessor :top_box, :bottom_box
          attr_accessor :left_box, :right_box

          # margins
          attr_accessor :top_margin, :bottom_margin, :left_margin, :right_margin

          attr_accessor :enabled, :floating

          # dominance rating (must be supplied)
          attr_accessor :dominance

          # always overide this the default simply renders a box
          def render dc
            raise "layout error in #{self.class}" if x.nil? or y.nil? or width.nil? or height.nil?
            dc.setClipRectangle FXRectangle.new(x,y,width,height)
            dc.foreground = black
            dc.drawRectangle x, y, width-1, height-1
          end

          def enabled? ; enabled ; end
          def floating? ; floating ; end

          # calc the width and height of this box. Override!
          def calculate_dimensions
            self.width  ||= (hint_width || 20) #TODO: remove the cheats
            self.height ||= (hint_height || 10)
          end
          
          def initialize chart,
                         name: self.class,
                         float: false,
                         enabled: true,
                         dom: 1,
                         orient: :none,
                         placement: :unspecified
            @chart = chart
            @name = name
            @dominance = dom
            @floating = float
            @top_margin = @bottom_margin = @left_margin = @right_margin = 0
            @orientation = orient
            @enabled = enabled
          end

          def to_s
            sprintf "<%50s dom=%s xywh=%-17s LRTB=%-14s %s>" % [name,
                                                                "#{dominance}",
                                                                "[#{x||'NIL'},#{y||'NIL'},#{width||'NIL'},#{height||'NIL'}]",
                                                                "[#{left_margin},#{right_margin},#{top_margin},#{bottom_margin}]",
                                                                "#{floating? ? 'floater' : ''}"
                                                               ]
          end
        end

        # The null box represents the side of the container -- the
        # canvas -- and will simplify layout.
        class NullBox < Box
          def initialize chart, **kv
            super(chart, **kv)
            @dominance = 0
          end

          # null box is never rendered.
          def render dc ; end
        end              
        
        class Ruler < Box
          def render dc
            super
            #dc.
          end
          
          def initialize chart, **kv
            super
            @dominance = 2
          end
        end
        
        # For now, we assume that the placement
        # of PureText boxes shall be above and
        # below the GraphBox.
        class PureText < Box
          def calculate_wh
          end
          
          def calculate_dimensions
            super
            calculate_wh
            begin
              self.x = [top_box.width, bottom_box.width].max / 2 - self.width / 2
            rescue ArgumentError, NoMethodError, TypeError => e
              #puts "-->PureText unresolved: #{e}"
            end
          end
        end

        class Title < PureText
        end

        class Caption < PureText
        end

        class Legend < Box
          # We calculate this on the basis
          # of our actual content.
          def calculate_wh
            self.width = 50 # TODO: we're cheating again.
            self.height = 30
          end
          
          def calculate_dimensions
            super
            calculate_wh
            
            # This is a nasty hard-coding, which will not
            # allow us to change the location of this box.
            # Later, we'll want to add that flexibility.
            self.y = right_box.height / 2 - self.height / 2
          end
        end

        # main charting area.
        class Graph < Box
          def calculate_dimensions
            super
            begin
              self.width = right_box.x \
                           - right_box.left_margin \
                           - left_box.x \
                           - left_box.width \
                           + left_box.right_margin
              self.height = bottom_box.y \
                            - bottom_box.top_margin \
                            - top_box.y \
                            - top_box.height \
                            + top_box.bottom_margin
            rescue NoMethodError, TypeError => e
              #puts "-->Graph: unresolved: #{e}"
            end
          end
          
          def initialize chart, **kv
            super
            @dominance = 3
          end
        end
      end
    end
  end
end
