module ProconBypassManCommander
  module Splatoon3
    class TemplateMatcher
      class MatchedResult
        attr_accessor :x, :y, :correlation_value

        def initialize(x, y, correlation_value)
          @x = x
          @y = y
          @correlation_value = correlation_value
        end
      end

      # TODO: 3つでマッチングをする。3つのうち、2つが想定した範囲内の座標になっていれば、OKとする
      def self.match(target_path:, debug: false, first_template: , second_template: , third_template: , fourth_template: )
        image = OpenCV::cv::imread(target_path, OpenCV::cv::IMREAD_COLOR)

        gray_image = OpenCV::cv::Mat.new
        gray_template = OpenCV::cv::Mat.new
        gray_second_template = OpenCV::cv::Mat.new
        gray_third_template = OpenCV::cv::Mat.new
        gray_fourth_template = OpenCV::cv::Mat.new
        OpenCV::cv::cvtColor(image, gray_image, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(first_template, gray_template, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(second_template, gray_second_template, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(third_template, gray_third_template, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(fourth_template, gray_fourth_template, OpenCV::cv::COLOR_BGR2GRAY)

        # テンプレートマッチングの対象範囲を限定する
        width = gray_image.cols
        width_middle_start = (width / 7 * 3).floor # 7分割して中央を対象にする
        width_middle_end = (width / 7 * 4).floor
        height = gray_image.rows
        height_middle_start = (height / 3).floor  # 3分割して中央を対象にする
        height_middle_end = (2 * height / 3).floor
        cutted_cropped_gray_image = gray_image.col_range(width_middle_start, width_middle_end)
        cropped_gray_image = cutted_cropped_gray_image.row_range(height_middle_start, height_middle_end)

        # 1回目のマッチング
        matching_result = do_matching(cropped_gray_image, gray_template)
        first_matching_correlation_value, match_location = calc_location(matching_result)
        first_matching_x = match_location.x
        first_matching_y = match_location.y
        match_location.x += width_middle_start
        match_location.y += height_middle_start
        OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + first_template.cols, match_location.y + first_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug

        # 2回目のマッチング
        matching_result = do_matching(cropped_gray_image, gray_second_template)
        second_match_correlation_value, match_location = calc_location(matching_result)
        second_matching_x = match_location.x
        second_matching_y = match_location.y
        match_location.x += width_middle_start
        match_location.y += height_middle_start
        OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + second_template.cols, match_location.y + second_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug

        # 3回目のマッチング
        matching_result = do_matching(cropped_gray_image, gray_third_template)
        third_match_correlation_value, match_location = calc_location(matching_result)
        third_matching_x = match_location.x
        third_matching_y = match_location.y
        match_location.x += width_middle_start
        match_location.y += height_middle_start
        OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + third_template.cols, match_location.y + third_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug

        # 4回目のマッチング
        matching_result = do_matching(cropped_gray_image, gray_fourth_template)
        fourth_match_correlation_value, match_location = calc_location(matching_result)
        fourth_matching_x = match_location.x
        fourth_matching_y = match_location.y
        match_location.x += width_middle_start
        match_location.y += height_middle_start
        OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + third_template.cols, match_location.y + fourth_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug

        if debug
          OpenCV::cv::imwrite("#{target_path.gsub('.png', '')}-result.png", image)
        end

        return [
          MatchedResult.new(first_matching_x, first_matching_y, first_matching_correlation_value),
          MatchedResult.new(second_matching_x, second_matching_y, second_match_correlation_value),
          MatchedResult.new(third_matching_x, third_matching_y, third_match_correlation_value),
          MatchedResult.new(fourth_matching_x, fourth_matching_y, fourth_match_correlation_value),
        ]
      end

      def self.do_matching(target_image, template)
        result_cols = target_image.cols - template.cols + 1
        result_rows = target_image.rows - template.rows + 1
        matching_result = OpenCV::cv::Mat.new(result_rows, result_cols, OpenCV::cv::CV_32FC1)
        OpenCV::cv::match_template(target_image, template, matching_result, match_method)
        matching_result
      end

      def self.calc_location(result)
        min_location = OpenCV::cv::Point.new
        max_location = OpenCV::cv::Point.new
        min_val, max_val = OpenCV::cv::min_max_loc(result, min_location, max_location)
        if match_method == OpenCV::cv::TM_SQDIFF || match_method == OpenCV::cv::TM_SQDIFF_NORMED
          second_match_correlation_value = min_val
          match_location = min_location
        else
          second_match_correlation_value = max_val
          match_location = max_location
        end

        return [second_match_correlation_value, match_location]
      end

      def self.match_method
        OpenCV::cv::TM_CCOEFF_NORMED
      end
    end
  end
end
