module ProconBypassManCommander
  module Splatoon3
    class EnemyTargetDetector
      # @return [Boolean]
      def self.detect?(target_path, debug: false)
        matched_up_position, matched_down_position = ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: target_path, debug: debug)
        return false if matched_up_position.nil?

        within_threshold(matched_up_position.x, matched_down_position.x, 5) && within_threshold(matched_up_position.y, matched_down_position.y, 15)
      end

      def self.within_threshold(x, y, threshold)
        (x - y).abs <= threshold
      end
    end
  end
end
