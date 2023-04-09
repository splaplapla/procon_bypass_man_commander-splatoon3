require "procon_bypass_man_commander/splatoon3/version"

module ProconBypassManCommander
  module Splatoon3
    class TemplateMatcher
      # よくある前処理の実装例
      # image = OpenCV::cv::imread(target_path, OpenCV::cv::IMREAD_COLOR)
      # template = OpenCV::cv::imread(template_path, OpenCV::cv::IMREAD_COLOR)
      # # ターゲット画像とテンプレート画像をグレースケールに変換します。
      # gray_image = OpenCV::cv::Mat.new
      # gray_template = OpenCV::cv::Mat.new
      # OpenCV::cv::cvtColor(image, gray_image, OpenCV::cv::COLOR_BGR2GRAY)
      # OpenCV::cv::cvtColor(template, gray_template, OpenCV::cv::COLOR_BGR2GRAY)
      # # ガウシアンブラーを適用してノイズを減らします。
      # blurred_image = OpenCV::cv::Mat.new
      # blurred_template = OpenCV::cv::Mat.new
      # OpenCV::cv::GaussianBlur(gray_image, blurred_image, OpenCV::cv::Size.new(5, 5), 0)
      # OpenCV::cv::GaussianBlur(gray_template, blurred_template, OpenCV::cv::Size.new(5, 5), 0)
      # # エッジ検出を行います（Cannyエッジ検出器を使用）
      # edges_image = OpenCV::cv::Mat.new
      # edges_template = OpenCV::cv::Mat.new
      # OpenCV::cv::canny(blurred_image, edges_image, 50, 150)
      # OpenCV::cv::canny(blurred_template, edges_template, 50, 150)
      # # エッジ検出された画像でテンプレートマッチングを実行します。
      # result_cols = edges_image.cols - edges_template.cols + 1
      # result_rows = edges_image.rows - edges_template.rows + 1
      # result = OpenCV::cv::Mat.new(result_rows, result_cols, OpenCV::cv::CV_32FC1)
      # match_method = OpenCV::cv::TM_CCOEFF_NORMED
      # OpenCV::cv::match_template(edges_image, edges_template, result, match_method)


      def self.match(target_path:, template_path: './lib/procon_bypass_man_commander/splatoon3/assets/template-sd.png')
        image = OpenCV::cv::imread(target_path, OpenCV::cv::IMREAD_COLOR)
        template = OpenCV::cv::imread(template_path, OpenCV::cv::IMREAD_COLOR)

        result_cols = image.cols - template.cols + 1
        result_rows = image.rows - template.rows + 1
        result = OpenCV::cv::Mat.new(result_rows, result_cols, OpenCV::cv::CV_32FC1)
        match_method = OpenCV::cv::TM_CCOEFF_NORMED
        OpenCV::cv::match_template(image, template, result, match_method)

        # NOTE: 判定結果をマーキング
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
