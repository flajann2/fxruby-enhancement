<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org0977442">1. fxruby-enhancement</a>
<ul>
<li><a href="#orgf7629a4">1.1. Introduction</a></li>
<li><a href="#org3d11194">1.2. Installation</a></li>
<li><a href="#org27fb6ec">1.3. Documentation</a>
<ul>
<li><a href="#orgc0dfebb">1.3.1. Events from other Threads</a></li>
<li><a href="#org8675cd0">1.3.2. binding.fx</a></li>
<li><a href="#orgb722ac8">1.3.3. Examples</a></li>
</ul>
</li>
<li><a href="#orgff11a07">1.4. <span class="todo TODO">TODO</span> Release Notes</a></li>
<li><a href="#orge9218d6">1.5. <span class="todo TODO">TODO</span> Known Issues</a></li>
<li><a href="#orgd02c7a5">1.6. Contributing to fxruby-enhancement</a></li>
<li><a href="#org6d61ea7">1.7. Copyright</a></li>
<li><a href="#org59eb834">1.8. The Scratchpad</a>
<ul>
<li><a href="#org642246c">1.8.1. Genesis of the meta-meta programming, whereby brain goes boom</a></li>
</ul>
</li>
</ul>
</li>
</ul>
</div>
</div>


<a id="org0977442"></a>

# fxruby-enhancement


<a id="orgf7629a4"></a>

## Introduction

The fxruby library is an excellent wrapper for the FOX toolkit. However, it reflects the
C++-ness of FOX, rather than being more Ruby-like. As such, creating composed objects with
it tends to be rather ugly and cumbersome.

fxruby-enhancement is a wrapper for the wrapper, to "rubyfy" it and make it more easy to 
use for Rubyists. 

fxruby-enhancement is basically a DSL of sorts, and every effort has been taken to make 
it intuitive to use. Once you get the hang of it, you should be able to look at the FXRuby
API documentation and infer the DSL construct for fxruby-enhancement.


<a id="org3d11194"></a>

## Installation

To install the gem from commandline:

    gem install fxruby-enhancement

In your Gemfile:

    gem "fxruby-enhancement", "~> 0"

fxruby-enhacement depends on fxruby version 1.6, and
will automatically include it. However fxruby has a c-extension
that must compile properly on your system. Normally, this is not
a concern, but it is something to be aware of.


<a id="org27fb6ec"></a>

## Documentation


<a id="orgc0dfebb"></a>

### Events from other Threads

In handling interfacing to databases, AMQPs like RabbitMQ,
network connections, or just about anything else that might otherwise
slow down the GUI (Fox) thread and make it non-responsive, there needs 
to be a clean way to get data into and out of the GUI thread.

Fox provides some mechanisms specifically for sockets or system-level IO,
but these are too specific, and would require some awkard workarounds to
make them work in the general context.

And so we provide a means to accomplish that in a clean &#x2013; to you, anyway &#x2013;
manner. We make use of queue<sub>ding</sub> queues for passing messages into and out of
the FXRuby (and therefore FXRuby Enhancement) space. This will allow you to
keep the GUI thread responsive and also to maintain a seperation of concerns.

1.  The Queue<sub>Ding</sub> Queues

    1.  TODO Ingress
    
    2.  TODO Egress


<a id="org8675cd0"></a>

### binding.fx

This is a way to split up your layouts into different .fx "modules", purely for
organizational reasons. For example,

    binding.fx "overview"

will load the overview.fx portion of the GUI, which happens to be a tab contents
in the tab book, which in our case looks like:

    # Overview Tab
    
    fx_tab_item { text "&Overview" }
    fx_horizontal_frame (:overview_info) {
      opts STD_FRAME|LAYOUT_FILL_Y
    
      fx_group_box (:ov_connections_group) {
        text "Connections"
        opts STD_GROUPBOX|LAYOUT_FILL_Y
    
        fx_vertical_frame {
          opts LAYOUT_FILL_Y|LAYOUT_FILL_X #|PACK_UNIFORM_HEIGHT
    
          fx_group_box (:ov_conn_rabbitmq) {
    ...


<a id="orgb722ac8"></a>

### Examples

Class-based enhancement (this has not been tested yet!!!):

    class Main < FXMainWindow
      compose :my_window do
        title "RubyNEAT Panel"
        show PLACEMENT_SCREEN
        width 700
        height 400
        fx_tab_book :my_book do |tab_book_ob|
          x 0
          y 0
          width 500
          height 100
          pad_bottom 10
          fx_text :my_text1, :my_window { |text_ob|
            width 200
            height 100
            text_ob.target my_window: :on_click
          }
          fx_text :my_text2, :my_window { |text_ob|
            width 200
            height 100
            text_ob { |t| puts "called after object initialization" }
          }
        end
      end
    
      def on_click
        ...
      end
    end

Class-free enhancement:

    mw = fx_main_window :my_window do 
        title "RubyNEAT Panel"
        width 700
        height 400
        opts DECOR_ALL
        x 10
        y 10
        instance { show PLACEMENT_SCREEN }
        fx_tab_book :my_book do |tab_book_ob|
          x 0
          y 0
          width 500
          height 100
          pad_bottom 10
          fx_text :my_text1, :my_window { |text_ob|
            width 200
            height 100
            instance my_window: :on_click
          }
          fx_text :my_text2, :my_window { 
            width 200
            height 100
            instance { |t| puts "called after object initialization" }
          }
        end
      end
    
      def mw.on_click
        ...
      end
    end

[Hello World](examples/hello.rb) example (full):

    #!/usr/bin/env ruby
    require 'fxruby-enhancement'
    
    include Fox
    include Fox::Enhancement::Mapper
    
    fx_app :app do
      app_name "Hello"
      vendor_name "Example"
    
      fx_main_window(:main) {
        title "Hello"
        opts DECOR_ALL
    
        fx_button {
          text "&Hello, World"
          selector FXApp::ID_QUIT
    
          instance { |b|
            b.target = ref(:app)
          }
        }
    
        instance { |w|
          w.show PLACEMENT_SCREEN
        }
      }
    end
    
    # alias for fox_component is fxc
    fox_component :app do |app|
      app.launch
    end

[Bouncing Ball](examples/bounce.rb) example (full):

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


<a id="orgff11a07"></a>

## Release Notes


<a id="orge9218d6"></a>

## Known Issues


<a id="orgd02c7a5"></a>

## Contributing to fxruby-enhancement

-   Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
-   Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
-   Fork the project.
-   Start a feature/bugfix branch.
-   Commit and push until you are happy with your contribution.
-   Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
-   Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


<a id="org6d61ea7"></a>

## Copyright

Copyright (c) 2016-2017 Fred Mitchell. See LICENSE.txt for
further details.


<a id="org59eb834"></a>

## The Scratchpad

These are my personal notes, not meant for anyone else.
You may see some interesting tidbits here, but I am not
gauranteeing anything to be useful or reliable in this
section. YOU HAVE BEEN WARNED.


<a id="org642246c"></a>

### Genesis of the meta-meta programming, whereby brain goes boom

        class FXToolBar # monkey patch
          include Enhancement
          attr_accessor :_o
        end
    
        def fx_tool_bar name, &block # DSL
          o = OStruct.new
          o.title = "default title"
          ...
    
          def o.title t 
            @title = t
          end    
    
          def o.instance a, &block
            o.instance_time_block = block
          end
          f = FXToolBar.new ...
          f._o = o
        end
    
    <% for @class, @details in @api %>
       #<%= @class %> < <%= @details[:class][1] %>
       <% unless @details[:initialize].nil? %>
          <% for @iniparams in @details[:initialize] %>
             #<%= @iniparams %>   
          <% end %>
       <% else %>
          #No initializer
       <% end %>
    <% end %>

