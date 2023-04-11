module ProconBypassManCommander
  module Splatoon3
    # TODO: shooter用なのでリネームする
    class EnemyTargetDetectorHD
      FIRST_TEMPLATE_PATH = './lib/procon_bypass_man_commander/splatoon3/assets/hd/template-up.png'
      SECOND_TEMPLATE_PATH = './lib/procon_bypass_man_commander/splatoon3/assets/hd/template-down.png'

      CENTER_TEMPLATE_PATH = './lib/procon_bypass_man_commander/splatoon3/assets/hd/template-center.png'
      NEGATIVE_CENTER_TEMPLATE_PATH = './lib/procon_bypass_man_commander/splatoon3/assets/hd/template-negative-center.png'

      @@first_template = OpenCV::cv::imread(FIRST_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)
      @@second_template = OpenCV::cv::imread(SECOND_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)

      @@center_template = OpenCV::cv::imread(CENTER_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)
      @@negative_center_template = OpenCV::cv::imread(NEGATIVE_CENTER_TEMPLATE_PATH, OpenCV::cv::IMREAD_COLOR)

      # @return [Boolean]
      def self.detect?(target_path, debug: false, mode: :part_matching)
        if mode == :part_matching
          threshold = 0.7
          matched_up_result, matched_down_result = ProconBypassManCommander::Splatoon3::TemplateMatcher.match(
            target_path: target_path,
            debug: debug,
            first_template: @@first_template,
            second_template: @@second_template,
            negative_template: @@negative_center_template,
          )
          return false if matched_up_result.nil?

          # 上下
          result = within_threshold(matched_up_result.x, matched_down_result.x, 5) &&
            within_threshold(matched_up_result.y, matched_down_result.y, 30) &&
            (matched_up_result.correlation_value > threshold || matched_down_result.correlation_value > threshold)
          # # 左と上
          # result = result || within_threshold(matched_up_result.x, matched_left_result.x, 5) &&
          #   (matched_up_result.correlation_value > threshold || matched_down_result.correlation_value > threshold)
          # # 左と下
          # result = result || within_threshold(matched_down_result.x, matched_left_result.x, 5) &&
          #   (matched_up_result.correlation_value > threshold || matched_down_result.correlation_value > threshold)

          yield(result, [matched_up_result, matched_down_result]) if block_given? # NOTE: for debug
          return result
        else
          threshold = 0.63
          matched_center_result = ProconBypassManCommander::Splatoon3::TemplateMatcher.match(
            target_path: target_path,
            debug: debug,
            first_template: @@center_template,
            negative_template: @@negative_center_template,
          )
          return false if matched_center_result.nil?
          result =  matched_center_result.correlation_value > threshold
          yield(result, [matched_center_result]) if block_given? # NOTE: for debug
          return result
        end
      end

      def self.within_threshold(x, y, threshold)
        (x - y).abs <= threshold
      end
    end
  end
end
