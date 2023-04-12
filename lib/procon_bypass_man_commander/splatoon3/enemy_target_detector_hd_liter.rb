module ProconBypassManCommander
  module Splatoon3
    class EnemyTargetDetectorHDLiter
      FIRST_TEMPLATE_PATH = File.join(__dir__, 'assets', 'hd', 'liter', 'template-up.png')
      SECOND_TEMPLATE_PATH = File.join(__dir__, 'assets', 'hd', 'liter', 'template-down.png')
      NEGATIVE_CENTER_TEMPLATE_PATH = File.join(__dir__, 'assets', 'hd', 'liter', 'template-negative-center.png')

      @@first_template = OpenCV::cv::imread(FIRST_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)
      @@second_template = OpenCV::cv::imread(SECOND_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)
      @@negative_center_template = OpenCV::cv::imread(NEGATIVE_CENTER_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)

      # @return [Boolean]
      def self.detect?(target_path, debug: false, mode: :part_matching)
        threshold = 0.6
        matched_up_result, matched_down_result, negative_matched_result = ProconBypassManCommander::Splatoon3::TemplateMatcher.match(
          target_path: target_path,
          debug: debug,
          first_template: @@first_template,
          second_template: @@second_template,
          negative_template: @@negative_center_template,
        )
        return false if matched_up_result.nil?

        if matched_up_result.y == matched_down_result.y
          return false
        end

        # 上下が近すぎるとだめ
        if matched_down_result.y - matched_up_result.y <= 9
          return false
        end

        result = within_threshold(matched_up_result.x, matched_down_result.x, 3) &&
          within_threshold(matched_up_result.y, matched_down_result.y, 20) &&
          (matched_up_result.correlation_value > threshold || matched_down_result.correlation_value > threshold)

        # upとネガティブマークのX座標は近いはずなので、乖離しているとだめ
        result = result && within_threshold(matched_up_result.x, negative_matched_result.x, 5) &&
          within_threshold(matched_up_result.x, negative_matched_result.x, 5)
        # upとネガティブマークのY座標は近いはずなので、乖離しているとだめ
        result = result && within_threshold(matched_down_result.y, negative_matched_result.y, 20) &&
          within_threshold(matched_down_result.y, negative_matched_result.y, 20)

        yield(result, [matched_up_result, matched_down_result]) if block_given? # NOTE: for debug
        return result
      end

      def self.within_threshold(x, y, threshold)
        (x - y).abs <= threshold
      end
    end
  end
end
