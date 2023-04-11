module ProconBypassManCommander
  module Splatoon3
    # TODO: shooter用なのでリネームする
    class EnemyTargetDetector
      THRESHOLD = 0.63

      FIRST_TEMPLATE_PATH = './lib/procon_bypass_man_commander/splatoon3/assets/template-up-sd.png'
      SECOND_TEMPLATE_PATH = './lib/procon_bypass_man_commander/splatoon3/assets/template-down-sd.png'
      THIRD_TEMPLATE_PATH = './lib/procon_bypass_man_commander/splatoon3/assets/template-left-sd.png'
      FOURTH_TEMPLATE_PATH = './lib/procon_bypass_man_commander/splatoon3/assets/template-right-sd.png'

      @@template = OpenCV::cv::imread(FIRST_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)
      @@second_template = OpenCV::cv::imread(SECOND_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)
      @@third_template = OpenCV::cv::imread(THIRD_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)
      @@fourth_template = OpenCV::cv::imread(FOURTH_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)

      # @return [Boolean]
      def self.detect?(target_path, debug: false, threshold: THRESHOLD)
        matched_up_result, matched_down_result, matched_left_result = ProconBypassManCommander::Splatoon3::TemplateMatcher.match(
          target_path: target_path,
          debug: debug,
          first_template: @@template,
          second_template: @@second_template,
          third_template: @@third_template,
          fourth_template: @@fourth_template,
        )
        return false if matched_up_result.nil?

        yield(matched_up_result, matched_down_result) if block_given? # NOTE: for debug

        # 上下
        result = within_threshold(matched_up_result.x, matched_down_result.x, 5) &&
          within_threshold(matched_up_result.y, matched_down_result.y, 15) &&
          (matched_up_result.correlation_value > threshold || matched_down_result.correlation_value > threshold)

        # # 左と上
        # result = result || within_threshold(matched_up_result.x, matched_left_result.x, 5) &&
        #   (matched_up_result.correlation_value > threshold || matched_down_result.correlation_value > threshold)

        # # 左と下
        # result = result || within_threshold(matched_down_result.x, matched_left_result.x, 5) &&
        #   (matched_up_result.correlation_value > threshold || matched_down_result.correlation_value > threshold)

        result
      end

      def self.within_threshold(x, y, threshold)
        (x - y).abs <= threshold
      end
    end
  end
end
