require "procon_bypass_man_commander/splatoon3/version"

module ProconBypassManCommander
  module Splatoon3
    class TemplateMatcher
      def self.match(target_path:, template_path: './lib/procon_bypass_man_commander/splatoon3/assets/template-sd.png')
        image = OpenCV::cv::imread(target_path, OpenCV::cv::IMREAD_COLOR)
        template = OpenCV::cv::imread(template_path, OpenCV::cv::IMREAD_COLOR)

        result_cols = image.cols - template.cols + 1
        result_rows = image.rows - template.rows + 1
        result = OpenCV::cv::Mat.new(result_rows, result_cols, OpenCV::cv::CV_32FC1)
        match_method = OpenCV::cv::TM_CCOEFF_NORMED
        OpenCV::cv::match_template(image, template, result, match_method)

        min_loc = OpenCV::cv::Point.new
        max_loc = OpenCV::cv::Point.new
        min_val, max_val = OpenCV::cv::min_max_loc(result, min_loc, max_loc)

        if match_method == OpenCV::cv::TM_SQDIFF || match_method == OpenCV::cv::TM_SQDIFF_NORMED
          match_loc = min_loc
        else
          match_loc = max_loc
        end

        OpenCV::cv::rectangle(image, match_loc, OpenCV::cv::Point.new(match_loc.x + template.cols, match_loc.y + template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0)

        result_image_path = "#{target_path}-result.png"
        OpenCV::cv::imwrite(result_image_path, image)
      end
    end
  end
end
