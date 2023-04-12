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

      class NegativeMatchedResult < MatchedResult; end


      class CroppedImage
        def initialize(image)
          @image = image
          width = image.cols
          @width_middle_start = (width / 7 * 3).floor # 7分割して中央を対象にする
          width_middle_end = (width / 7 * 4).floor
          height = image.rows
          @height_middle_start = (height / 3).floor  # 3分割して中央を対象にする
          height_middle_end = (2 * height / 3).floor
          cutted_cropped_image = image.col_range(@width_middle_start, width_middle_end)
          @cropped_image = cutted_cropped_image.row_range(@height_middle_start, height_middle_end)
        end

        def width_middle_start
          @width_middle_start
        end

        def height_middle_start
          @height_middle_start
        end

        def raw_image
          @cropped_image
        end
      end

      # TODO: 3つでマッチングをする。3つのうち、2つが想定した範囲内の座標になっていれば、OKとする
      def self.match(target_path:, debug: false, first_template: , second_template: nil, third_template: nil, fourth_template: nil, negative_template: nil)
        @results = []
        if target_path.is_a?(String)
          image = OpenCV::cv::imread(target_path, OpenCV::cv::IMREAD_COLOR)
        else
          image = target_path
        end

        gray_image = OpenCV::cv::Mat.new
        gray_negative_template = OpenCV::cv::Mat.new
        OpenCV::cv::cvtColor(image, gray_image, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(negative_template, gray_negative_template, OpenCV::cv::COLOR_BGR2GRAY) if negative_template

        cropped_image = CroppedImage.new(gray_image)
        cropped_gray_image = cropped_image.raw_image # テンプレートマッチングの対象範囲を限定する

        if negative_template
          # ネガティブテンプレートのマッチング
          matching_result = do_matching(cropped_gray_image, gray_negative_template)
          negative_matching_correlation_value, match_location = calc_location(matching_result, cropped_image)
          OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + gray_negative_template.cols, match_location.y + gray_negative_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug
          OpenCV::cv::imwrite("#{target_path.gsub('.png', '')}-negative-result.png", image) if debug
          if negative_matching_correlation_value > 0.9
            puts "ネガティブテンプレートと相関が高い(#{negative_matching_correlation_value})"
            return nil
          end

          negative_matched_result = NegativeMatchedResult.new(match_location.x, match_location.y, negative_matching_correlation_value)
        end

        if second_template.nil?
          gray_image = OpenCV::cv::Mat.new
          gray_first_template = OpenCV::cv::Mat.new
          OpenCV::cv::cvtColor(image, gray_image, OpenCV::cv::COLOR_BGR2GRAY)
          OpenCV::cv::cvtColor(first_template, gray_first_template, OpenCV::cv::COLOR_BGR2GRAY)

          # 1回目のマッチング
          matching_result = do_matching(cropped_gray_image, gray_first_template)
          first_matching_correlation_value, match_location = calc_location(matching_result, cropped_image)
          add_result(match_location, first_matching_correlation_value)
          OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + first_template.cols, match_location.y + first_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug

          if debug
            OpenCV::cv::imwrite("#{target_path.gsub('.png', '')}-result.png", image)
          end

          return @results.first
        end

        gray_image = OpenCV::cv::Mat.new
        gray_first_template = OpenCV::cv::Mat.new
        gray_second_template = OpenCV::cv::Mat.new
        gray_third_template = OpenCV::cv::Mat.new if third_template
        gray_fourth_template = OpenCV::cv::Mat.new if fourth_template
        OpenCV::cv::cvtColor(image, gray_image, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(first_template, gray_first_template, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(second_template, gray_second_template, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(third_template, gray_third_template, OpenCV::cv::COLOR_BGR2GRAY) if third_template
        OpenCV::cv::cvtColor(fourth_template, gray_fourth_template, OpenCV::cv::COLOR_BGR2GRAY) if fourth_template

        # 1回目のマッチング
        matching_result = do_matching(cropped_gray_image, gray_first_template)
        first_matching_correlation_value, match_location = calc_location(matching_result, cropped_image)
        add_result(match_location, first_matching_correlation_value)
        OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + first_template.cols, match_location.y + first_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug

        # 2回目のマッチング
        matching_result = do_matching(cropped_gray_image, gray_second_template)
        second_match_correlation_value, match_location = calc_location(matching_result, cropped_image)
        add_result(match_location, second_match_correlation_value)
        OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + second_template.cols, match_location.y + second_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug

        # 3回目のマッチング
        if third_template
          matching_result = do_matching(cropped_gray_image, gray_third_template)
          third_match_correlation_value, match_location = calc_location(matching_result, cropped_image)
          add_result(match_location, third_match_correlation_value)
          OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + third_template.cols, match_location.y + third_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug
        end

        # 4回目のマッチング
        if fourth_template
          matching_result = do_matching(cropped_gray_image, gray_fourth_template)
          fourth_match_correlation_value, match_location = calc_location(matching_result, cropped_image)
          add_result(match_location, fourth_match_correlation_value)
          OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + third_template.cols, match_location.y + fourth_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0) if debug
        end

        if debug
          OpenCV::cv::imwrite("#{target_path.gsub('.png', '')}-result.png", image)
        end

        @results << negative_matched_result
        return @results
      end

      def self.add_result(match_location, correlation_value)
        @results ||= []
        @results << MatchedResult.new(match_location.x, match_location.y, correlation_value)
      end

      def self.do_matching(target_image, template)
        result_cols = target_image.cols - template.cols + 1
        result_rows = target_image.rows - template.rows + 1
        matching_result = OpenCV::cv::Mat.new(result_rows, result_cols, OpenCV::cv::CV_32FC1)
        OpenCV::cv::match_template(target_image, template, matching_result, match_method)
        matching_result
      end

      def self.calc_location(result, cropped_image)
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

        match_location.x += cropped_image.width_middle_start
        match_location.y += cropped_image.height_middle_start
        return [second_match_correlation_value, match_location]
      end

      def self.match_method
        OpenCV::cv::TM_CCOEFF_NORMED
      end
    end
  end
end
