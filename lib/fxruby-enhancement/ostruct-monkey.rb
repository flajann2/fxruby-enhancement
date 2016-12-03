class OpenStruct
  # This assumes this OpenStruct instance represents the base,
  # and additionaly will take an optional object to use as the
  # actual base to allow for composures.
  def create_fox_components use_as_base = nil
    unless use_as_base.nil?
      self.inst = fx.()
      self.kinder.each{ |os| os.create_fox_components }
    else
      OpenStruct.new(klass: use_as_base.class,
                     kinder: [self],
                     fx: ->() {use_as_base}).create_fox_components
    end
  end
end

