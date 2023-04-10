module ProconBypassManCommander
  module Splatoon3
    # TODO: shooter用なのでリネームする
    class EnemyTargetDetector
      THRESHOLD = 0.63

      # @return [Boolean]
      def self.detect?(target_path, debug: false, threshold: THRESHOLD)
        matched_up_result, matched_down_result = ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: target_path, debug: debug)
        return false if matched_up_result.nil?

        yield(matched_up_result, matched_down_result) if block_given? # NOTE: for debug

        within_threshold(matched_up_result.x, matched_down_result.x, 5) &&
        within_threshold(matched_up_result.y, matched_down_result.y, 15) &&
        (matched_up_result.correlation_value > threshold || matched_down_result.correlation_value > threshold)
      end

      def self.within_threshold(x, y, threshold)
        (x - y).abs <= threshold
      end
    end
  end
end
