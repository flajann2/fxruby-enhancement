# coding: utf-8
require_relative 'charting-boxes'
require_relative 'charting-mapper'

module Fox
  module Enhancement
    module Xtras
      # Charting constructs. Note that the
      # rulers have built-in their own labeling, with orientation.
      module Charting        
        class Chart
          extend Forwardable
          include RGB
          
          def_delegators :@canvas, :width, :height, :visual
          def_delegators :@cos, :type, :axial,
                         :data, :set_data, :add_to_data,
                         :series, :domain, :range,
                         :background, :caption, :title
          
          attr_accessor :buffer, :x_range, :y_range
          
          def initialize cos, canvas
            @cos = cos
            @canvas = canvas
            @x_range = domain
            @y_range = range
            
            initial_parameter_setup
            initial_chart_layout            
            backlink_boxes
          end

          def set_x_range range
            @x_range = range
          end
          
          def set_y_range range
            @y_range = range
          end

          def draw_dc &block
            @buffer.starten if @buffer.inst.nil?
            FXDCWindow.new(@buffer.inst) { |dc| block.(dc) }
          end

          # Data is expected to be a vector (Array) or an Array of vectors,
          # in the same format as configured. Any missing elements in the
          # vector must be nil. If no more data is expected on an element,
          # make it :eos (end of stream)
          def add_to_series newdata
            if newdata.first.is_a? Array # array of vectors
              add_to_data newdata
              compute_data_ranges newdata
            else # single vector
              add_to_data [newdata]
              compute_data_ranges [newdata]
            end
            update_chart newrange: false
          end
          
          def update_chart newrange: true
            compute_data_ranges if newrange
            layout_boxes
            draw_dc { |dc|
              dc.setForeground @cos.background.color || white
              dc.fillRectangle 0, 0, width, height
              dc.drawImage @buffer.inst, 0, 0
              @layout.map{ |name, box| box }
                .reject{ |box| box.nil? }
                .select{ |box| box.enabled? }
                .each{ |box| box.render(dc) }
            }
            @canvas.update
            @canvas.repaint
          end

          private

          # TODO: for some strange reason, we needed to do
          # TODO: the assignment of the ranges seperately
          # TODO: from incorporation.
          def compute_data_ranges dat = data
            pp dat, x_range, y_range
            dat.map{ |a| [a.first, a[1..-1]]}
              .each{ |x, vec|
              set_x_range x_range.incorporate(x)
              vec.each{ |y| set_y_range y_range.incorporate(y) }
            }
          end
          
          def layout_box box
            if box.dominance == 0
              null_box_layout box
            else
              general_box_layout box
            end
          end

          def general_box_layout box
            box.calculate_dimensions
            subordinate_box_layout box
            superior_box_layout box
          end

          def subordinate_box_layout box
            subordinates(box).each { |sub|
              begin
                case sub
                when box.left_box
                  box.x = sub.x + sub.width + sub.right_margin + box.left_margin
                when box.right_box
                  box.x = sub.x - sub.left_margin - box.right_margin - box.width
                when box.top_box
                  box.y = sub.y + sub.height + sub.bottom_margin + box.top_margin
                when box.bottom_box                  
                  box.y = sub.y - sub.top_margin - box.bottom_margin - box.height
                end
              rescue NoMethodError, TypeError => e
                #puts "-->subortinate unresolved: #{e}"
              end
            }
          end

          def superior_box_layout box
            superiors(box).each { |sup|
              begin
                case sup
                when box.left_box
                  box.height = sup.height 
                  box.y = sup.y
                  box.x = sup.x + sup.width + sup.right_margin + box.left_margin
                when box.right_box
                  box.height = sup.height
                  box.y = sup.y                                        
                when box.top_box
                  box.width = sup.width
                  box.x = sup.x
                when box.bottom_box
                  box.width = sup.width
                  box.x = sup.x
                end
              rescue NoMethodError, TypeError => e
                #puts "-->superior unresolved: #{e}"
              end unless box.floating?
            }
          end
          
          def null_box_layout box
            case box.name
            when :null_left
              box.x = 0
              box.y = 0
              box.width = 0
              box.height = height
            when :null_right
              box.x = width
              box.y = 0
              box.width = 0
              box.height = height
            when :null_top
              box.x = 0
              box.y = 0
              box.width = width
              box.height = 0
            when :null_bottom
              box.x = 0
              box.y = height
              box.width = width
              box.height = 0
            end              
          end
          
          def initial_parameter_setup
            as (:app) {
              @buffer = fx_image { opts IMAGE_KEEP }
            }
            
            @x_ruler_width = 20
            @y_ruler_height = 20
            @font_title = nil
            @font_caption = nil
            @font_ledgend = nil
            @font_axis_name = nil
          end
          
          def initial_chart_layout
            lytbox = ->(klass, **kv){ [kv[:name], klass.new(self, **kv)] }
            @layout = lyt = [
              lytbox.(NullBox, name: :null_left,    placement: :left),
              lytbox.(NullBox, name: :null_right,   placement: :right),
              lytbox.(NullBox, name: :null_top,     placement: :top),
              lytbox.(NullBox, name: :null_bottom,  placement: :bottom),
              lytbox.(Title,   name: :title,        float: true),
              lytbox.(Ruler,   name: :top_ruler,    axial: @cos.axial, orient: :horizontal, placement: :top),
              lytbox.(Ruler,   name: :bottom_ruler, axial: @cos.axial, orient: :horizontal, placement: :bottom),
              lytbox.(Ruler,   name: :left_ruler,   axial: @cos.axial, orient: :vertical,   placement: :left),
              lytbox.(Ruler,   name: :right_ruler,  axial: @cos.axial, orient: :vertical,   placement: :right),
              lytbox.(Caption, name: :caption,      float: true),
              lytbox.(Legend,  name: :legend,       float: true),
              lytbox.(Graph,   name: :graph)
            ].to_h
            
            # bottom connections
            lyt[:null_top].bottom_box     = lyt[:title]
            lyt[:title].bottom_box        = lyt[:top_ruler]
            lyt[:top_ruler].bottom_box    = lyt[:graph]
            lyt[:graph].bottom_box        = lyt[:bottom_ruler]
            lyt[:bottom_ruler].bottom_box = lyt[:caption]
            lyt[:caption].bottom_box      = lyt[:null_bottom]

            # right connections
            lyt[:null_left].right_box     = lyt[:left_ruler]
            lyt[:left_ruler].right_box    = lyt[:graph]
            lyt[:graph].right_box         = lyt[:right_ruler]
            lyt[:right_ruler].right_box   = lyt[:legend]
            lyt[:legend].right_box        = lyt[:null_right]
          end
          
          # call inially and when there's an update.
          def layout_boxes
            clear_all_boxes
            recalculate_dimensions
            
            # first pass -- out to in
            (0..Box::MAX_DOMINANCE).each do |dom|
              boxes_of_dominance(dom).each{ |box| layout_box box }
            end
            
            # second pass -- in to out
            (1..Box::MAX_DOMINANCE).to_a.reverse.each do |dom|
              boxes_of_dominance(dom).each{ |box| layout_box box }
            end
          end

          # All x,y,width,height are nilled for all boxes
          def clear_all_boxes
            @layout.each { |name, box|
              box.x = box.y = box.width = box.height = nil
            }
          end

          def recalculate_dimensions
            @layout.each { |name, box|
              box.calculate_dimensions
            }
          end
          
          # Give a list of subordinates
          def subordinates box
            Box::NÄHE.map{ |b| box.send(b) }
              .reject { |b| b.nil? }
              .select { |nbox| box.dominance > nbox.dominance }            
          end
          
          # Give a list of superiors
          def superiors box
            Box::NÄHE.map{ |b| box.send(b) }
              .reject { |b| b.nil? }
              .select { |nbox| box.dominance < nbox.dominance }            
          end

          # return all boxes with the proscribed dominance
          def boxes_of_dominance dom
            @layout.map{ |name, box| box }.select{ |box| box.dominance == dom }
          end
          
          def backlink_boxes
            @layout.each{ |name, box|
              box.bottom_box.top_box = box unless box.bottom_box.nil?
              box.right_box.left_box = box unless box.right_box.nil?
            }
            unlink_disabled_boxes
          end

          def unlink_disabled_boxes
            @layout.map{ |name, box| box }
              .reject{ |box| box.enabled? }
              .each{ |box|
              box.top_box.bottom_box = box.bottom_box
              box.bottom_box.top_box = box.top_box
              box.left_box.right_box = box.right_box
              box.right_box.left_box = box.left_box
            }
          end
        end
      end
    end    
  end
end

