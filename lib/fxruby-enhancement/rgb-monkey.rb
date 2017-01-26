# coding: utf-8
=begin rdoc
color = RGB::Color.from_rgb_hex("#333333")
color = RGB::Color.from_rgb_hex(0xFF0000)
color = RGB::Color.from_rgb(115, 38, 38)
color = RGB::Color.from_fractions(0, 1.0, 0.5) # HSL

# Supported color manipulations:
color.darken(20)
color.darken_percent(10)
color.darken!(20)
color.darken_percent!(10)
color.lighten(20)
color.lighten_percent(20)
color.lighten!(20)
color.lighten_percent!(20)
color.saturate(20)
color.saturate_percent(20)
color.saturate!(20)
color.saturate_percent!(20)
color.desaturate(20)
color.desaturate_percent(20)
color.desaturate!(20)
color.desaturate_percent!(20)

color.invert!

# Mixing colors:
color.mix(other_color, 20) # Mix 20% of other color into current one
color.mix(other_color) # 50% by default
color.mix!(other_color, 20)
color.mix!(other_color)

# Also you can adjust color HSL (hue, saturation, and lightness values) manually:
color.hue = 0.1
color.saturation = 0.2
color.lightness = 0.3

# Supported output formats:
color.to_rgb_hex
=> "#732626"
color.to_hsl
=> [0, 1.0, 0.5]
color.to_rgb
=> [115, 38, 38]

=end

require_relative "color-mapper"

module RGB
  class Color
    def to_fx
    end
  end
end

