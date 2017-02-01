module Fox 

  # Include this in your top class objects.
  # If for a module, you want to extend, rather
  # than include.
  # FIXME: later we will clean this up.
  module Enhancement
    @stack = []
    @base = nil
    @components = {}
    @kinder_parents = {}
    SPECIAL = [:FXApp,
               :FXColorItem,
               :FXRegion,
               :FXRectangle,
               :FXGradient,
               :FXEvent,
               :FXDataTarget,
               :FXFileStream,
               :FXExtentd]
    INITFORCE = { FXMenuBar: 1 }
    
    # Module-level    
    class << self
      attr_accessor :stack,
                    :kinder_parents, # this is to make 'as' delecrations work intuitively.
                    :base, # the very first component declared, usually the app.
                    :components,
                    :deferred_setups,
                    :ms_ingress_delay_min,
                    :ms_ingress_delay_max
      
      # queues for messages objects coming from and going to other threads.
      attr_accessor :ingress, :egress, :ingress_map
      
      def included(klass)
        @ingress ||= QDing.new
        @egress  ||= QDing.new
        @ingress_map ||= {}
        @deferred_setups ||= []
        @ms_ingress_delay_min = 100
        @ms_ingress_delay_max = 1600
        
        klass.extend ClassMethods
      end

      def reset_components
        @components = {}
      end

      # Sets up the mechanism by which the custom ingress is activated
      def activate_ingress_handlers app = Enhancement.base
        raise "Application Object not instantiated yet" if app.nil? || app.inst.nil?
        raise "No ingress blocks set" if @ingress_map.empty?
        
        @ing_blk = ->(sender, sel, data) { 
          begin
            unless @ingress.empty?
              @ingress_delay = @ms_ingress_delay_min
              until @ingress.empty?
                dispatch_to, payload = @ingress.next
                raise "Unknown dispatch ':#{dispatch_to}'" unless @ingress_map.member? dispatch_to
                @ingress_map[dispatch_to].(dispatch_to, payload)
              end
            else
              @ingress_delay *= 2 unless @ingress_delay >= @ms_ingress_delay_max
            end
          ensure
            app.inst.addTimeout(@ingress_delay, &@ing_blk)
          end
        }
        app.inst.addTimeout(@ingress_delay ||= @ms_ingress_delay_min, &@ing_blk)
      end

      def activate_deferred_setups common_ob, app: Enhancement.base
        Enhancement.deferred_setups.each { |b| b.(common_ob, app) }
      end
    end

    # class level
    module ClassMethods
      def compose &block #DSL
        @composure = block
      end      
    end

    # instance level
    # Add it here.
    
    module Mapper
      # Find the referenced component's instance
      def ref sym, &block
        raise "No reference for #{sym} found" if Enhancement.components[sym].nil?
        raise "No instance for #{sym} allocated" if Enhancement.components[sym].inst.nil?
        inst = Enhancement.components[sym].inst
        if block_given?
          block.(inst)
        end
        return inst
      end

      def rgb
      end
      
      # Find the referenced component's wrapper object
      def refc sym, &block
        raise "No reference component for #{sym} found" if Enhancement.components[sym].nil?
        c = Enhancement.components[sym]
        if block_given?
          block.(c)
        end
        return c
      end

      # Wrapper component
      def fox_component name, &block
        if block_given?
          block.(Enhancement.components[name])
        else
          Enhancement.components[name]
        end
      end
      alias_method :fxc, :fox_component

      # Actual FX Object instance
      def fox_instance name, &block
        if block_given?
          block.(fox_component(name).inst)
        else
          fox_component(name).inst
        end
      end
      alias_method :fxi, :fox_instance

      # To allow for adding new components at
      # other places other than the immediate
      # parental nesting.
      def as tag, kpos: Enhancement.stack.last, &block
        Enhancement.stack << (@os = os = refc(tag))

        # We must add our actual parent to the kinder parent
        # registry, and remove it before we're done here.
        kstacklvl = Enhancement.stack.size + 1
        Enhancement.kinder_parents[kstacklvl] = kpos
        
        def instance a=nil, &block
          @os.instance_name = a
          @os.instance_block ||= []
          @os.instance_block << [a, block]
        end
        
        self.instance_eval &block

        Enhancement.kinder_parents.delete kstacklvl
        Enhancement.stack.pop                                                  
        @os = Enhancement.stack.last
        return os
      end
      
      # Handles incomming external messages of type given
      # block, written by user, is called with |type, message|.
      # Zero or more symbols may be given,
      # in which case the given block will
      # be associated with all the given symbols.
      def ingress_handler *types, &block
        raise "No block given" unless block_given?
        types = [:all] if types.empty?
        types.each do |type|
          Enhancement.ingress_map[type] = block
        end
      end

      # This is invoked after we have
      # a real application in place. Invocation
      # of this is held off until the last possible
      # moment.
      # TODO: Not sure we need this. This may go away.
      def deferred_setup &block
        Enhancement.deferred_setups << block
      end
    end
  end
end
