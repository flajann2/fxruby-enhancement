# coding: utf-8
=begin rdoc
This is a color map for Enhancement to make it
easier to deal with colors in FXRuby.

To use, just do:
  include RGB
== List of available colors

  * white

  * black

  * red

  * pink

  * orange

  * yellow

  * green

  * magenta

  * cyan

  * blue

  * ghost_white

  * white_smoke

  * floral_white

  * old_lace

  * antique_white

  * papaya_whip

  * blanched_almond

  * peach_puff

  * navajo_white

  * lemon_chiffon

  * mint_cream

  * alice_blue

  * lavender_blush

  * misty_rose

  * dark_slate_grey

  * dim_grey

  * slate_grey

  * light_slate_grey

  * light_gray

  * midnight_blue

  * navy_blue

  * cornflower_blue

  * dark_slate_blue

  * slate_blue

  * medium_slate_blue

  * light_slate_blue

  * medium_blue

  * royal_blue

  * dodger_blue

  * deep_sky_blue

  * sky_blue

  * light_sky_blue

  * steel_blue

  * light_steel_blue

  * light_blue

  * powder_blue

  * pale_turquoise

  * dark_turquoise

  * medium_turquoise

  * light_cyan

  * cadet_blue

  * medium_aquamarine

  * dark_green

  * dark_olive_green

  * dark_sea_green

  * sea_green

  * medium_sea_green

  * light_sea_green

  * pale_green

  * spring_green

  * lawn_green

  * medium_spring_green

  * green_yellow

  * lime_green

  * yellow_green

  * forest_green

  * olive_drab

  * dark_khaki

  * pale_goldenrod

  * light_goldenrod_yellow

  * light_yellow

  * light_goldenrod

  * dark_goldenrod

  * rosy_brown

  * indian_red

  * saddle_brown

  * sandy_brown

  * dark_salmon

  * light_salmon

  * dark_orange

  * light_coral

  * orange_red

  * hot_pink

  * deep_pink

  * light_pink

  * pale_violet_red

  * medium_violet_red

  * violet_red

  * medium_orchid

  * dark_orchid

  * dark_violet

  * blue_violet

  * medium_purple

  * antique_white1

  * antique_white2

  * antique_white3

  * antique_white4

  * peach_puff1

  * peach_puff2

  * peach_puff3

  * peach_puff4

  * navajo_white1

  * navajo_white2

  * navajo_white3

  * navajo_white4

  * lemon_chiffon1

  * lemon_chiffon2

  * lemon_chiffon3

  * lemon_chiffon4

  * lavender_blush1

  * lavender_blush2

  * lavender_blush3

  * lavender_blush4

  * misty_rose1

  * misty_rose2

  * misty_rose3

  * misty_rose4

  * slate_blue1

  * slate_blue2

  * slate_blue3

  * slate_blue4

  * royal_blue1

  * royal_blue2

  * royal_blue3

  * royal_blue4

  * dodger_blue1

  * dodger_blue2

  * dodger_blue3

  * dodger_blue4

  * steel_blue1

  * steel_blue2

  * steel_blue3

  * steel_blue4

  * deep_sky_blue1

  * deep_sky_blue2

  * deep_sky_blue3

  * deep_sky_blue4

  * sky_blue1

  * sky_blue2

  * sky_blue3

  * sky_blue4

  * light_sky_blue1

  * light_sky_blue2

  * light_sky_blue3

  * light_sky_blue4

  * slate_gray1

  * slate_gray2

  * slate_gray3

  * slate_gray4

  * light_steel_blue1

  * light_steel_blue2

  * light_steel_blue3

  * light_steel_blue4

  * light_blue1

  * light_blue2

  * light_blue3

  * light_blue4

  * light_cyan1

  * light_cyan2

  * light_cyan3

  * light_cyan4

  * pale_turquoise1

  * pale_turquoise2

  * pale_turquoise3

  * pale_turquoise4

  * cadet_blue1

  * cadet_blue2

  * cadet_blue3

  * cadet_blue4

  * dark_slate_gray1

  * dark_slate_gray2

  * dark_slate_gray3

  * dark_slate_gray4

  * dark_sea_green1

  * dark_sea_green2

  * dark_sea_green3

  * dark_sea_green4

  * sea_green1

  * sea_green2

  * sea_green3

  * sea_green4

  * pale_green1

  * pale_green2

  * pale_green3

  * pale_green4

  * spring_green1

  * spring_green2

  * spring_green3

  * spring_green4

  * olive_drab1

  * olive_drab2

  * olive_drab3

  * olive_drab4

  * dark_olive_green1

  * dark_olive_green2

  * dark_olive_green3

  * dark_olive_green4

  * light_goldenrod1

  * light_goldenrod2

  * light_goldenrod3

  * light_goldenrod4

  * light_yellow1

  * light_yellow2

  * light_yellow3

  * light_yellow4

  * dark_goldenrod1

  * dark_goldenrod2

  * dark_goldenrod3

  * dark_goldenrod4

  * rosy_brown1

  * rosy_brown2

  * rosy_brown3

  * rosy_brown4

  * indian_red1

  * indian_red2

  * indian_red3

  * indian_red4

  * light_salmon1

  * light_salmon2

  * light_salmon3

  * light_salmon4

  * dark_orange1

  * dark_orange2

  * dark_orange3

  * dark_orange4

  * orange_red1

  * orange_red2

  * orange_red3

  * orange_red4

  * deep_pink1

  * deep_pink2

  * deep_pink3

  * deep_pink4

  * hot_pink1

  * hot_pink2

  * hot_pink3

  * hot_pink4

  * light_pink1

  * light_pink2

  * light_pink3

  * light_pink4

  * pale_violet_red1

  * pale_violet_red2

  * pale_violet_red3

  * pale_violet_red4

  * violet_red1

  * violet_red2

  * violet_red3

  * violet_red4

  * medium_orchid1

  * medium_orchid2

  * medium_orchid3

  * medium_orchid4

  * dark_orchid1

  * dark_orchid2

  * dark_orchid3

  * dark_orchid4

  * medium_purple1

  * medium_purple2

  * medium_purple3

  * medium_purple4

  * dark_grey

  * dark_gray

  * dark_blue

  * dark_cyan

  * dark_magenta

  * dark_red

  * light_green


== NOTE WELL
  This file is generated by fxruby-enhancement.
  Do NOT modify this file. Modify the ERB template
  file instead, and run 'rake scrape'.
=end

module RGB

  def white; Fox.FXRGB(255, 255, 255); end

  def black; Fox.FXRGB(0, 0, 0); end

  def red; Fox.FXRGB(255, 0, 0); end

  def pink; Fox.FXRGB(255, 175, 175); end

  def orange; Fox.FXRGB(255, 200, 0); end

  def yellow; Fox.FXRGB(255, 255, 0); end

  def green; Fox.FXRGB(0, 255, 0); end

  def magenta; Fox.FXRGB(255, 0, 255); end

  def cyan; Fox.FXRGB(0, 255, 255); end

  def blue; Fox.FXRGB(0, 0, 255) ; end

  def ghost_white; Fox.FXRGB(248, 248, 255); end

  def white_smoke; Fox.FXRGB(245, 245, 245); end

  def floral_white; Fox.FXRGB(255, 250, 240); end

  def old_lace; Fox.FXRGB(253, 245, 230); end

  def antique_white; Fox.FXRGB(250, 235, 215); end

  def papaya_whip; Fox.FXRGB(255, 239, 213); end

  def blanched_almond; Fox.FXRGB(255, 235, 205); end

  def peach_puff; Fox.FXRGB(255, 218, 185); end

  def navajo_white; Fox.FXRGB(255, 222, 173); end

  def lemon_chiffon; Fox.FXRGB(255, 250, 205); end

  def mint_cream; Fox.FXRGB(245, 255, 250); end

  def alice_blue; Fox.FXRGB(240, 248, 255); end

  def lavender_blush; Fox.FXRGB(255, 240, 245); end

  def misty_rose; Fox.FXRGB(255, 228, 225); end

  def dark_slate_grey; Fox.FXRGB( 47,  79,  79); end

  def dim_grey; Fox.FXRGB(105, 105, 105); end

  def slate_grey; Fox.FXRGB(112, 128, 144); end

  def light_slate_grey; Fox.FXRGB(119, 136, 153); end

  def light_gray; Fox.FXRGB(211, 211, 211); end

  def midnight_blue; Fox.FXRGB( 25,  25, 112); end

  def navy_blue; Fox.FXRGB(  0,   0, 128); end

  def cornflower_blue; Fox.FXRGB(100, 149, 237); end

  def dark_slate_blue; Fox.FXRGB( 72,  61, 139); end

  def slate_blue; Fox.FXRGB(106,  90, 205); end

  def medium_slate_blue; Fox.FXRGB(123, 104, 238); end

  def light_slate_blue; Fox.FXRGB(132, 112, 255); end

  def medium_blue; Fox.FXRGB(  0,   0, 205); end

  def royal_blue; Fox.FXRGB( 65, 105, 225); end

  def dodger_blue; Fox.FXRGB( 30, 144, 255); end

  def deep_sky_blue; Fox.FXRGB(  0, 191, 255); end

  def sky_blue; Fox.FXRGB(135, 206, 235); end

  def light_sky_blue; Fox.FXRGB(135, 206, 250); end

  def steel_blue; Fox.FXRGB( 70, 130, 180); end

  def light_steel_blue; Fox.FXRGB(176, 196, 222); end

  def light_blue; Fox.FXRGB(173, 216, 230); end

  def powder_blue; Fox.FXRGB(176, 224, 230); end

  def pale_turquoise; Fox.FXRGB(175, 238, 238); end

  def dark_turquoise; Fox.FXRGB(  0, 206, 209); end

  def medium_turquoise; Fox.FXRGB( 72, 209, 204); end

  def light_cyan; Fox.FXRGB(224, 255, 255); end

  def cadet_blue; Fox.FXRGB( 95, 158, 160); end

  def medium_aquamarine; Fox.FXRGB(102, 205, 170); end

  def dark_green; Fox.FXRGB(  0, 100,   0); end

  def dark_olive_green; Fox.FXRGB( 85, 107,  47); end

  def dark_sea_green; Fox.FXRGB(143, 188, 143); end

  def sea_green; Fox.FXRGB( 46, 139,  87); end

  def medium_sea_green; Fox.FXRGB( 60, 179, 113); end

  def light_sea_green; Fox.FXRGB( 32, 178, 170); end

  def pale_green; Fox.FXRGB(152, 251, 152); end

  def spring_green; Fox.FXRGB(  0, 255, 127); end

  def lawn_green; Fox.FXRGB(124, 252,   0); end

  def medium_spring_green; Fox.FXRGB(  0, 250, 154); end

  def green_yellow; Fox.FXRGB(173, 255,  47); end

  def lime_green; Fox.FXRGB( 50, 205,  50); end

  def yellow_green; Fox.FXRGB(154, 205,  50); end

  def forest_green; Fox.FXRGB( 34, 139,  34); end

  def olive_drab; Fox.FXRGB(107, 142,  35); end

  def dark_khaki; Fox.FXRGB(189, 183, 107); end

  def pale_goldenrod; Fox.FXRGB(238, 232, 170); end

  def light_goldenrod_yellow; Fox.FXRGB(250, 250, 210); end

  def light_yellow; Fox.FXRGB(255, 255, 224); end

  def light_goldenrod; Fox.FXRGB(238, 221, 130); end

  def dark_goldenrod; Fox.FXRGB(184, 134,  11); end

  def rosy_brown; Fox.FXRGB(188, 143, 143); end

  def indian_red; Fox.FXRGB(205,  92,  92); end

  def saddle_brown; Fox.FXRGB(139,  69,  19); end

  def sandy_brown; Fox.FXRGB(244, 164,  96); end

  def dark_salmon; Fox.FXRGB(233, 150, 122); end

  def light_salmon; Fox.FXRGB(255, 160, 122); end

  def dark_orange; Fox.FXRGB(255, 140,   0); end

  def light_coral; Fox.FXRGB(240, 128, 128); end

  def orange_red; Fox.FXRGB(255,  69,   0); end

  def hot_pink; Fox.FXRGB(255, 105, 180); end

  def deep_pink; Fox.FXRGB(255,  20, 147); end

  def light_pink; Fox.FXRGB(255, 182, 193); end

  def pale_violet_red; Fox.FXRGB(219, 112, 147); end

  def medium_violet_red; Fox.FXRGB(199,  21, 133); end

  def violet_red; Fox.FXRGB(208,  32, 144); end

  def medium_orchid; Fox.FXRGB(186,  85, 211); end

  def dark_orchid; Fox.FXRGB(153,  50, 204); end

  def dark_violet; Fox.FXRGB(148,   0, 211); end

  def blue_violet; Fox.FXRGB(138,  43, 226); end

  def medium_purple; Fox.FXRGB(147, 112, 219); end

  def antique_white1; Fox.FXRGB(255, 239, 219); end

  def antique_white2; Fox.FXRGB(238, 223, 204); end

  def antique_white3; Fox.FXRGB(205, 192, 176); end

  def antique_white4; Fox.FXRGB(139, 131, 120); end

  def peach_puff1; Fox.FXRGB(255, 218, 185); end

  def peach_puff2; Fox.FXRGB(238, 203, 173); end

  def peach_puff3; Fox.FXRGB(205, 175, 149); end

  def peach_puff4; Fox.FXRGB(139, 119, 101); end

  def navajo_white1; Fox.FXRGB(255, 222, 173); end

  def navajo_white2; Fox.FXRGB(238, 207, 161); end

  def navajo_white3; Fox.FXRGB(205, 179, 139); end

  def navajo_white4; Fox.FXRGB(139, 121,  94); end

  def lemon_chiffon1; Fox.FXRGB(255, 250, 205); end

  def lemon_chiffon2; Fox.FXRGB(238, 233, 191); end

  def lemon_chiffon3; Fox.FXRGB(205, 201, 165); end

  def lemon_chiffon4; Fox.FXRGB(139, 137, 112); end

  def lavender_blush1; Fox.FXRGB(255, 240, 245); end

  def lavender_blush2; Fox.FXRGB(238, 224, 229); end

  def lavender_blush3; Fox.FXRGB(205, 193, 197); end

  def lavender_blush4; Fox.FXRGB(139, 131, 134); end

  def misty_rose1; Fox.FXRGB(255, 228, 225); end

  def misty_rose2; Fox.FXRGB(238, 213, 210); end

  def misty_rose3; Fox.FXRGB(205, 183, 181); end

  def misty_rose4; Fox.FXRGB(139, 125, 123); end

  def slate_blue1; Fox.FXRGB(131, 111, 255); end

  def slate_blue2; Fox.FXRGB(122, 103, 238); end

  def slate_blue3; Fox.FXRGB(105,  89, 205); end

  def slate_blue4; Fox.FXRGB( 71,  60, 139); end

  def royal_blue1; Fox.FXRGB( 72, 118, 255); end

  def royal_blue2; Fox.FXRGB( 67, 110, 238); end

  def royal_blue3; Fox.FXRGB( 58,  95, 205); end

  def royal_blue4; Fox.FXRGB( 39,  64, 139); end

  def dodger_blue1; Fox.FXRGB( 30, 144, 255); end

  def dodger_blue2; Fox.FXRGB( 28, 134, 238); end

  def dodger_blue3; Fox.FXRGB( 24, 116, 205); end

  def dodger_blue4; Fox.FXRGB( 16,  78, 139); end

  def steel_blue1; Fox.FXRGB( 99, 184, 255); end

  def steel_blue2; Fox.FXRGB( 92, 172, 238); end

  def steel_blue3; Fox.FXRGB( 79, 148, 205); end

  def steel_blue4; Fox.FXRGB( 54, 100, 139); end

  def deep_sky_blue1; Fox.FXRGB(  0, 191, 255); end

  def deep_sky_blue2; Fox.FXRGB(  0, 178, 238); end

  def deep_sky_blue3; Fox.FXRGB(  0, 154, 205); end

  def deep_sky_blue4; Fox.FXRGB(  0, 104, 139); end

  def sky_blue1; Fox.FXRGB(135, 206, 255); end

  def sky_blue2; Fox.FXRGB(126, 192, 238); end

  def sky_blue3; Fox.FXRGB(108, 166, 205); end

  def sky_blue4; Fox.FXRGB( 74, 112, 139); end

  def light_sky_blue1; Fox.FXRGB(176, 226, 255); end

  def light_sky_blue2; Fox.FXRGB(164, 211, 238); end

  def light_sky_blue3; Fox.FXRGB(141, 182, 205); end

  def light_sky_blue4; Fox.FXRGB( 96, 123, 139); end

  def slate_gray1; Fox.FXRGB(198, 226, 255); end

  def slate_gray2; Fox.FXRGB(185, 211, 238); end

  def slate_gray3; Fox.FXRGB(159, 182, 205); end

  def slate_gray4; Fox.FXRGB(108, 123, 139); end

  def light_steel_blue1; Fox.FXRGB(202, 225, 255); end

  def light_steel_blue2; Fox.FXRGB(188, 210, 238); end

  def light_steel_blue3; Fox.FXRGB(162, 181, 205); end

  def light_steel_blue4; Fox.FXRGB(110, 123, 139); end

  def light_blue1; Fox.FXRGB(191, 239, 255); end

  def light_blue2; Fox.FXRGB(178, 223, 238); end

  def light_blue3; Fox.FXRGB(154, 192, 205); end

  def light_blue4; Fox.FXRGB(104, 131, 139); end

  def light_cyan1; Fox.FXRGB(224, 255, 255); end

  def light_cyan2; Fox.FXRGB(209, 238, 238); end

  def light_cyan3; Fox.FXRGB(180, 205, 205); end

  def light_cyan4; Fox.FXRGB(122, 139, 139); end

  def pale_turquoise1; Fox.FXRGB(187, 255, 255); end

  def pale_turquoise2; Fox.FXRGB(174, 238, 238); end

  def pale_turquoise3; Fox.FXRGB(150, 205, 205); end

  def pale_turquoise4; Fox.FXRGB(102, 139, 139); end

  def cadet_blue1; Fox.FXRGB(152, 245, 255); end

  def cadet_blue2; Fox.FXRGB(142, 229, 238); end

  def cadet_blue3; Fox.FXRGB(122, 197, 205); end

  def cadet_blue4; Fox.FXRGB( 83, 134, 139); end

  def dark_slate_gray1; Fox.FXRGB(151, 255, 255); end

  def dark_slate_gray2; Fox.FXRGB(141, 238, 238); end

  def dark_slate_gray3; Fox.FXRGB(121, 205, 205); end

  def dark_slate_gray4; Fox.FXRGB( 82, 139, 139); end

  def dark_sea_green1; Fox.FXRGB(193, 255, 193); end

  def dark_sea_green2; Fox.FXRGB(180, 238, 180); end

  def dark_sea_green3; Fox.FXRGB(155, 205, 155); end

  def dark_sea_green4; Fox.FXRGB(105, 139, 105); end

  def sea_green1; Fox.FXRGB( 84, 255, 159); end

  def sea_green2; Fox.FXRGB( 78, 238, 148); end

  def sea_green3; Fox.FXRGB( 67, 205, 128); end

  def sea_green4; Fox.FXRGB( 46, 139,  87); end

  def pale_green1; Fox.FXRGB(154, 255, 154); end

  def pale_green2; Fox.FXRGB(144, 238, 144); end

  def pale_green3; Fox.FXRGB(124, 205, 124); end

  def pale_green4; Fox.FXRGB( 84, 139,  84); end

  def spring_green1; Fox.FXRGB(  0, 255, 127); end

  def spring_green2; Fox.FXRGB(  0, 238, 118); end

  def spring_green3; Fox.FXRGB(  0, 205, 102); end

  def spring_green4; Fox.FXRGB(  0, 139,  69); end

  def olive_drab1; Fox.FXRGB(192, 255,  62); end

  def olive_drab2; Fox.FXRGB(179, 238,  58); end

  def olive_drab3; Fox.FXRGB(154, 205,  50); end

  def olive_drab4; Fox.FXRGB(105, 139,  34); end

  def dark_olive_green1; Fox.FXRGB(202, 255, 112); end

  def dark_olive_green2; Fox.FXRGB(188, 238, 104); end

  def dark_olive_green3; Fox.FXRGB(162, 205,  90); end

  def dark_olive_green4; Fox.FXRGB(110, 139,  61); end

  def light_goldenrod1; Fox.FXRGB(255, 236, 139); end

  def light_goldenrod2; Fox.FXRGB(238, 220, 130); end

  def light_goldenrod3; Fox.FXRGB(205, 190, 112); end

  def light_goldenrod4; Fox.FXRGB(139, 129,  76); end

  def light_yellow1; Fox.FXRGB(255, 255, 224); end

  def light_yellow2; Fox.FXRGB(238, 238, 209); end

  def light_yellow3; Fox.FXRGB(205, 205, 180); end

  def light_yellow4; Fox.FXRGB(139, 139, 122); end

  def dark_goldenrod1; Fox.FXRGB(255, 185,  15); end

  def dark_goldenrod2; Fox.FXRGB(238, 173,  14); end

  def dark_goldenrod3; Fox.FXRGB(205, 149,  12); end

  def dark_goldenrod4; Fox.FXRGB(139, 101,   8); end

  def rosy_brown1; Fox.FXRGB(255, 193, 193); end

  def rosy_brown2; Fox.FXRGB(238, 180, 180); end

  def rosy_brown3; Fox.FXRGB(205, 155, 155); end

  def rosy_brown4; Fox.FXRGB(139, 105, 105); end

  def indian_red1; Fox.FXRGB(255, 106, 106); end

  def indian_red2; Fox.FXRGB(238,  99,  99); end

  def indian_red3; Fox.FXRGB(205,  85,  85); end

  def indian_red4; Fox.FXRGB(139,  58,  58); end

  def light_salmon1; Fox.FXRGB(255, 160, 122); end

  def light_salmon2; Fox.FXRGB(238, 149, 114); end

  def light_salmon3; Fox.FXRGB(205, 129,  98); end

  def light_salmon4; Fox.FXRGB(139,  87,  66); end

  def dark_orange1; Fox.FXRGB(255, 127,   0); end

  def dark_orange2; Fox.FXRGB(238, 118,   0); end

  def dark_orange3; Fox.FXRGB(205, 102,   0); end

  def dark_orange4; Fox.FXRGB(139,  69,   0); end

  def orange_red1; Fox.FXRGB(255,  69,   0); end

  def orange_red2; Fox.FXRGB(238,  64,   0); end

  def orange_red3; Fox.FXRGB(205,  55,   0); end

  def orange_red4; Fox.FXRGB(139,  37,   0); end

  def deep_pink1; Fox.FXRGB(255,  20, 147); end

  def deep_pink2; Fox.FXRGB(238,  18, 137); end

  def deep_pink3; Fox.FXRGB(205,  16, 118); end

  def deep_pink4; Fox.FXRGB(139,  10,  80); end

  def hot_pink1; Fox.FXRGB(255, 110, 180); end

  def hot_pink2; Fox.FXRGB(238, 106, 167); end

  def hot_pink3; Fox.FXRGB(205,  96, 144); end

  def hot_pink4; Fox.FXRGB(139,  58,  98); end

  def light_pink1; Fox.FXRGB(255, 174, 185); end

  def light_pink2; Fox.FXRGB(238, 162, 173); end

  def light_pink3; Fox.FXRGB(205, 140, 149); end

  def light_pink4; Fox.FXRGB(139,  95, 101); end

  def pale_violet_red1; Fox.FXRGB(255, 130, 171); end

  def pale_violet_red2; Fox.FXRGB(238, 121, 159); end

  def pale_violet_red3; Fox.FXRGB(205, 104, 137); end

  def pale_violet_red4; Fox.FXRGB(139,  71,  93); end

  def violet_red1; Fox.FXRGB(255,  62, 150); end

  def violet_red2; Fox.FXRGB(238,  58, 140); end

  def violet_red3; Fox.FXRGB(205,  50, 120); end

  def violet_red4; Fox.FXRGB(139,  34,  82); end

  def medium_orchid1; Fox.FXRGB(224, 102, 255); end

  def medium_orchid2; Fox.FXRGB(209,  95, 238); end

  def medium_orchid3; Fox.FXRGB(180,  82, 205); end

  def medium_orchid4; Fox.FXRGB(122,  55, 139); end

  def dark_orchid1; Fox.FXRGB(191,  62, 255); end

  def dark_orchid2; Fox.FXRGB(178,  58, 238); end

  def dark_orchid3; Fox.FXRGB(154,  50, 205); end

  def dark_orchid4; Fox.FXRGB(104,  34, 139); end

  def medium_purple1; Fox.FXRGB(171, 130, 255); end

  def medium_purple2; Fox.FXRGB(159, 121, 238); end

  def medium_purple3; Fox.FXRGB(137, 104, 205); end

  def medium_purple4; Fox.FXRGB( 93,  71, 139); end

  def dark_grey; Fox.FXRGB(169, 169, 169); end

  def dark_gray; Fox.FXRGB(169, 169, 169); end

  def dark_blue; Fox.FXRGB(0  ,   0, 139); end

  def dark_cyan; Fox.FXRGB(0  , 139, 139); end

  def dark_magenta; Fox.FXRGB(139,   0, 139); end

  def dark_red; Fox.FXRGB(139,   0,   0); end

  def light_green; Fox.FXRGB(144, 238, 144); end

end
