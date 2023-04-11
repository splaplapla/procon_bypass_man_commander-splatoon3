require "ropencv"

require "procon_bypass_man_commander/splatoon3/version"
require "procon_bypass_man_commander/splatoon3/template_matcher"
require "procon_bypass_man_commander/splatoon3/enemy_target_detector_360p"
require "procon_bypass_man_commander/splatoon3/enemy_target_detector_hd"
require "procon_bypass_man_commander/splatoon3/enemy_target_detector_hd_liter"

module ProconBypassManCommander
  module Splatoon3
    SUPPORT_PIXEL_RESOLUTIONS = {
      '360p' => '640x360',
      'hd' => '1280x720',
    }
  end
end
