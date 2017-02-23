#!/usr/bin/env ruby
# coding: utf-8
require 'fxruby-enhancement'

include Fox
include Fox::Enhancement::Mapper
include RGB

# Here we show a list of colors. This is for illustrative
# purposes. See the code starting from line 283. :)

LIST_OF_COLORS = { 
  white: white,
  black: black,
  red: red,
  pink: pink,
  orange: orange,
  yellow: yellow,
  green: green,
  magenta: magenta,
  cyan: cyan,
  blue: blue,
  ghost_white: ghost_white,
  white_smoke: white_smoke,
  floral_white: floral_white,
  old_lace: old_lace,
  antique_white: antique_white,
  papaya_whip: papaya_whip,
  blanched_almond: blanched_almond,
  peach_puff: peach_puff,
  navajo_white: navajo_white,
  lemon_chiffon: lemon_chiffon,
  mint_cream: mint_cream,
  alice_blue: alice_blue,
  lavender_blush: lavender_blush,
  misty_rose: misty_rose,
  dark_slate_grey: dark_slate_grey,
  dim_grey: dim_grey,
  slate_grey: slate_grey,
  light_slate_grey: light_slate_grey,
  light_gray: light_gray,
  midnight_blue: midnight_blue,
  navy_blue: navy_blue,
  cornflower_blue: cornflower_blue,
  dark_slate_blue: dark_slate_blue,
  slate_blue: slate_blue,
  medium_slate_blue: medium_slate_blue,
  light_slate_blue: light_slate_blue,
  medium_blue: medium_blue,
  royal_blue: royal_blue,
  dodger_blue: dodger_blue,
  deep_sky_blue: deep_sky_blue,
  sky_blue: sky_blue,
  light_sky_blue: light_sky_blue,
  steel_blue: steel_blue,
  light_steel_blue: light_steel_blue,
  light_blue: light_blue,
  powder_blue: powder_blue,
  pale_turquoise: pale_turquoise,
  dark_turquoise: dark_turquoise,
  medium_turquoise: medium_turquoise,
  light_cyan: light_cyan,
  cadet_blue: cadet_blue,
  medium_aquamarine: medium_aquamarine,
  dark_green: dark_green,
  dark_olive_green: dark_olive_green,
  dark_sea_green: dark_sea_green,
  sea_green: sea_green,
  medium_sea_green: medium_sea_green,
  light_sea_green: light_sea_green,
  pale_green: pale_green,
  spring_green: spring_green,
  lawn_green: lawn_green,
  medium_spring_green: medium_spring_green,
  green_yellow: green_yellow,
  lime_green: lime_green,
  yellow_green: yellow_green,
  forest_green: forest_green,
  olive_drab: olive_drab,
  dark_khaki: dark_khaki,
  pale_goldenrod: pale_goldenrod,
  light_goldenrod_yellow: light_goldenrod_yellow,
  light_yellow: light_yellow,
  light_goldenrod: light_goldenrod,
  dark_goldenrod: dark_goldenrod,
  rosy_brown: rosy_brown,
  indian_red: indian_red,
  saddle_brown: saddle_brown,
  sandy_brown: sandy_brown,
  dark_salmon: dark_salmon,
  light_salmon: light_salmon,
  dark_orange: dark_orange,
  light_coral: light_coral,
  orange_red: orange_red,
  hot_pink: hot_pink,
  deep_pink: deep_pink,
  light_pink: light_pink,
  pale_violet_red: pale_violet_red,
  medium_violet_red: medium_violet_red,
  violet_red: violet_red,
  medium_orchid: medium_orchid,
  dark_orchid: dark_orchid,
  dark_violet: dark_violet,
  blue_violet: blue_violet,
  medium_purple: medium_purple,
  antique_white1: antique_white1,
  antique_white2: antique_white2,
  antique_white3: antique_white3,
  antique_white4: antique_white4,
  peach_puff1: peach_puff1,
  peach_puff2: peach_puff2,
  peach_puff3: peach_puff3,
  peach_puff4: peach_puff4,
  navajo_white1: navajo_white1,
  navajo_white2: navajo_white2,
  navajo_white3: navajo_white3,
  navajo_white4: navajo_white4,
  lemon_chiffon1: lemon_chiffon1,
  lemon_chiffon2: lemon_chiffon2,
  lemon_chiffon3: lemon_chiffon3,
  lemon_chiffon4: lemon_chiffon4,
  lavender_blush1: lavender_blush1,
  lavender_blush2: lavender_blush2,
  lavender_blush3: lavender_blush3,
  lavender_blush4: lavender_blush4,
  misty_rose1: misty_rose1,
  misty_rose2: misty_rose2,
  misty_rose3: misty_rose3,
  misty_rose4: misty_rose4,
  slate_blue1: slate_blue1,
  slate_blue2: slate_blue2,
  slate_blue3: slate_blue3,
  slate_blue4: slate_blue4,
  royal_blue1: royal_blue1,
  royal_blue2: royal_blue2,
  royal_blue3: royal_blue3,
  royal_blue4: royal_blue4,
  dodger_blue1: dodger_blue1,
  dodger_blue2: dodger_blue2,
  dodger_blue3: dodger_blue3,
  dodger_blue4: dodger_blue4,
  steel_blue1: steel_blue1,
  steel_blue2: steel_blue2,
  steel_blue3: steel_blue3,
  steel_blue4: steel_blue4,
  deep_sky_blue1: deep_sky_blue1,
  deep_sky_blue2: deep_sky_blue2,
  deep_sky_blue3: deep_sky_blue3,
  deep_sky_blue4: deep_sky_blue4,
  sky_blue1: sky_blue1,
  sky_blue2: sky_blue2,
  sky_blue3: sky_blue3,
  sky_blue4: sky_blue4,
  light_sky_blue1: light_sky_blue1,
  light_sky_blue2: light_sky_blue2,
  light_sky_blue3: light_sky_blue3,
  light_sky_blue4: light_sky_blue4,
  slate_gray1: slate_gray1,
  slate_gray2: slate_gray2,
  slate_gray3: slate_gray3,
  slate_gray4: slate_gray4,
  light_steel_blue1: light_steel_blue1,
  light_steel_blue2: light_steel_blue2,
  light_steel_blue3: light_steel_blue3,
  light_steel_blue4: light_steel_blue4,
  light_blue1: light_blue1,
  light_blue2: light_blue2,
  light_blue3: light_blue3,
  light_blue4: light_blue4,
  light_cyan1: light_cyan1,
  light_cyan2: light_cyan2,
  light_cyan3: light_cyan3,
  light_cyan4: light_cyan4,
  pale_turquoise1: pale_turquoise1,
  pale_turquoise2: pale_turquoise2,
  pale_turquoise3: pale_turquoise3,
  pale_turquoise4: pale_turquoise4,
  cadet_blue1: cadet_blue1,
  cadet_blue2: cadet_blue2,
  cadet_blue3: cadet_blue3,
  cadet_blue4: cadet_blue4,
  dark_slate_gray1: dark_slate_gray1,
  dark_slate_gray2: dark_slate_gray2,
  dark_slate_gray3: dark_slate_gray3,
  dark_slate_gray4: dark_slate_gray4,
  dark_sea_green1: dark_sea_green1,
  dark_sea_green2: dark_sea_green2,
  dark_sea_green3: dark_sea_green3,
  dark_sea_green4: dark_sea_green4,
  sea_green1: sea_green1,
  sea_green2: sea_green2,
  sea_green3: sea_green3,
  sea_green4: sea_green4,
  pale_green1: pale_green1,
  pale_green2: pale_green2,
  pale_green3: pale_green3,
  pale_green4: pale_green4,
  spring_green1: spring_green1,
  spring_green2: spring_green2,
  spring_green3: spring_green3,
  spring_green4: spring_green4,
  olive_drab1: olive_drab1,
  olive_drab2: olive_drab2,
  olive_drab3: olive_drab3,
  olive_drab4: olive_drab4,
  dark_olive_green1: dark_olive_green1,
  dark_olive_green2: dark_olive_green2,
  dark_olive_green3: dark_olive_green3,
  dark_olive_green4: dark_olive_green4,
  light_goldenrod1: light_goldenrod1,
  light_goldenrod2: light_goldenrod2,
  light_goldenrod3: light_goldenrod3,
  light_goldenrod4: light_goldenrod4,
  light_yellow1: light_yellow1,
  light_yellow2: light_yellow2,
  light_yellow3: light_yellow3,
  light_yellow4: light_yellow4,
  dark_goldenrod1: dark_goldenrod1,
  dark_goldenrod2: dark_goldenrod2,
  dark_goldenrod3: dark_goldenrod3,
  dark_goldenrod4: dark_goldenrod4,
  rosy_brown1: rosy_brown1,
  rosy_brown2: rosy_brown2,
  rosy_brown3: rosy_brown3,
  rosy_brown4: rosy_brown4,
  indian_red1: indian_red1,
  indian_red2: indian_red2,
  indian_red3: indian_red3,
  indian_red4: indian_red4,
  light_salmon1: light_salmon1,
  light_salmon2: light_salmon2,
  light_salmon3: light_salmon3,
  light_salmon4: light_salmon4,
  dark_orange1: dark_orange1,
  dark_orange2: dark_orange2,
  dark_orange3: dark_orange3,
  dark_orange4: dark_orange4,
  orange_red1: orange_red1,
  orange_red2: orange_red2,
  orange_red3: orange_red3,
  orange_red4: orange_red4,
  deep_pink1: deep_pink1,
  deep_pink2: deep_pink2,
  deep_pink3: deep_pink3,
  deep_pink4: deep_pink4,
  hot_pink1: hot_pink1,
  hot_pink2: hot_pink2,
  hot_pink3: hot_pink3,
  hot_pink4: hot_pink4,
  light_pink1: light_pink1,
  light_pink2: light_pink2,
  light_pink3: light_pink3,
  light_pink4: light_pink4,
  pale_violet_red1: pale_violet_red1,
  pale_violet_red2: pale_violet_red2,
  pale_violet_red3: pale_violet_red3,
  pale_violet_red4: pale_violet_red4,
  violet_red1: violet_red1,
  violet_red2: violet_red2,
  violet_red3: violet_red3,
  violet_red4: violet_red4,
  medium_orchid1: medium_orchid1,
  medium_orchid2: medium_orchid2,
  medium_orchid3: medium_orchid3,
  medium_orchid4: medium_orchid4,
  dark_orchid1: dark_orchid1,
  dark_orchid2: dark_orchid2,
  dark_orchid3: dark_orchid3,
  dark_orchid4: dark_orchid4,
  medium_purple1: medium_purple1,
  medium_purple2: medium_purple2,
  medium_purple3: medium_purple3,
  medium_purple4: medium_purple4,
  dark_grey: dark_grey,
  dark_gray: dark_gray,
  dark_blue: dark_blue,
  dark_cyan: dark_cyan,
  dark_magenta: dark_magenta,
  dark_red: dark_red,
  light_green: light_green, 
}

# color chart code begins here!
fx_app :app do
  app_name "Color Chart"
  vendor_name "Example"

  fx_main_window(:main) {
    title "Color Chart"
    opts DECOR_ALL
    
    instance { |w|
      w.show PLACEMENT_SCREEN
    }

    fx_horizontal_frame {
      LIST_OF_COLORS.each_slice(30) do |slice|
        fx_vertical_frame {
          slice.each do |name, color|
            fx_button {
              opts BUTTON_NORMAL | LAYOUT_SIDE_LEFT | LAYOUT_FILL_X
              text "#{name}"
              instance { |b|
                b.backColor = color
                b.textColor = color ^ 0xFFFFFF
              }
            }
          end
        }
      end
    }
  }
end

# alias for fox_component is fxc
fxc :app do |app|
  app.launch
end
