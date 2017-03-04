module Fox
  class FXDC
    def set_font_color font, color
      self.font = font
      self.foreground = color
    end
  end

  class FXFont
    # problems with getting height and width
    # on a rotated font!!!!
    attr_reader :realFontWidth, :realFontHeight
    attr_reader :realFontAscent, :realFontDescent
    
    def smart_create
      old_angle = angle
      setAngle 0      
      create
      @realFontWidth = getFontWidth
      @realFontHeight = getFontHeight
      @realFontAscent = getFontAscent
      @realFontDescent = getFontDescent
      destroy
      setAngle old_angle
      create
    end
  end
end
