# coding: utf-8
class OpenStruct
  extend Forwardable
  def_delegator :inst, :create,  :activate
  def_delegator :inst, :destroy, :deactivate
  def_delegator :inst, :run, :run_application  
  
  # This assumes this OpenStruct instance represents the base,
  # and additionaly will take an optional object to use as the
  # actual base to allow for composures.
  #
  # For the reuseable part of the tree, those are not created
  # right away. 
  #
  # Returns the os base
  def create_fox_components use_as_base = nil
    if use_as_base.nil?
      self.inst = fx.() if self.inst.nil?
      self.as_tasks.map{ |a| a.() } unless self.as_tasks.nil?
      self.kinder.each{ |os|
        os.create_fox_components unless os.reusable?
      }
    else
      OpenStruct.new(klass: use_as_base.class,
                     kinder: [self],
                     fx: ->() {use_as_base}).create_fox_components
    end
    self
  end

  def reusable?
    self.reusable
  end
  
  def destroy_fox_components all: false
    self.deactivate unless self.inst.nil?
    self.kinder.each{ |os|
      os.destroy_fox_components if all or not os.reusable?
    }
    self.inst = nil
  end

  # We can have as many instances as we like.
  def instance_final_activate
    self.instance_result =
      self.instance_block.map{ |name, inst|
      inst.(self.inst)
    } unless self.instance_block.nil?
    self.kinder
      .each{ |os|
      os.instance_final_activate unless os.reusable?
    }
    self
  end

  # launch the application
  def launch ingress: false
    create_fox_components
    instance_final_activate
    activate
    Enhancement.activate_ingress_handlers self if ingress
    run_application
  end
  
  # start the reusable components
  def starten
    create_fox_components
    instance_final_activate
    activate
  end

  # stop and deallocate the resusable components
  def stoppen
    destroy_fox_components
  end
end
