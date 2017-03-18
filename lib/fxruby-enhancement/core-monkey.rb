=begin rdoc
= Core (Kernel) classes we monkeypatched.
=end

class String
  def snake
    self.gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .tr("-", "_")
      .downcase
  end
end

class Symbol
  def snake
    self.to_s.snake.to_sym
  end
end

class Binding
  def fx fxf, dir=File.dirname(self.eval("__FILE__"))
    filepath = File.expand_path("#{fxf}.fx", dir)
    self.eval(File.read(filepath), filepath)
  end
end

class Range
  # incorporate the given value in the range,
  # and return a 'new' range.
  # TODO: this must handle #exclude_end? Right now
  # TODO: it ignores the distinction and assumes "..".
  def incorporate n
    unless include? n
      if n < self.begin
        n .. self.end
      elsif n >= self.end
        self.begin .. n
      end
    else
      self
    end
  end
end
