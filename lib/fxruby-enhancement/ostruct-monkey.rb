# coding: utf-8
class OpenStruct
  extend Forwardable
  def_delegator :inst, :create, :activate
  def_delegator :inst, :run, :run_application  
  
  # This assumes this OpenStruct instance represents the base,
  # and additionaly will take an optional object to use as the
  # actual base to allow for composures.
  #
  # Returns the os base
  def create_fox_components use_as_base = nil
    if use_as_base.nil?
      self.inst = fx.() if self.inst.nil?
      self.kinder.each{ |os| os.create_fox_components }
    else
      OpenStruct.new(klass: use_as_base.class,
                     kinder: [self],
                     fx: ->() {use_as_base}).create_fox_components
    end
    self
  end

  def instance_final_activate
    self.instance_result = self.instance_block.(self.inst) unless self.instance_block.nil?
    self.kinder.each{ |os| os.instance_final_activate }
    self
  end

  # launch the application
  def launch ingress: false, &block
    create_fox_components
    instance_final_activate
    activate
    Enhancement.activate_ingress_handlers self if ingress
    block.() if block_given?
    run_application
  end
end
