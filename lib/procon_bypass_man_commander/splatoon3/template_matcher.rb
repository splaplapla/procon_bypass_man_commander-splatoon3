require "procon_bypass_man_commander/splatoon3/version"


module ProconBypassManCommander
  module Splatoon3
    class TemplateMatcher
      THRESHOLD = 0.4

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


      def self.match(target_path:)
        first_template_path = './lib/procon_bypass_man_commander/splatoon3/assets/template-up-sd.png'
        second_template_path = './lib/procon_bypass_man_commander/splatoon3/assets/template-down-sd.png'

        image = OpenCV::cv::imread(target_path, OpenCV::cv::IMREAD_COLOR)
        template = OpenCV::cv::imread(first_template_path, OpenCV::cv::IMREAD_COLOR)
        second_template = OpenCV::cv::imread(second_template_path, OpenCV::cv::IMREAD_COLOR)

        gray_image = OpenCV::cv::Mat.new
        gray_template = OpenCV::cv::Mat.new
        gray_second_template = OpenCV::cv::Mat.new
        OpenCV::cv::cvtColor(image, gray_image, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(template, gray_template, OpenCV::cv::COLOR_BGR2GRAY)
        OpenCV::cv::cvtColor(second_template, gray_second_template, OpenCV::cv::COLOR_BGR2GRAY)

        # 画面中央のみ検査する
        width = gray_image.cols
        width_middle_start = (width / 7* 3).floor # 5分割
        width_middle_end = (width / 7 * 4).floor
        height = gray_image.rows
        height_middle_start = (height / 3).floor # 3分割
        height_middle_end = (2 * height / 3).floor
        cutted_cropped_gray_image = gray_image.col_range(width_middle_start, width_middle_end)
        cropped_gray_image = cutted_cropped_gray_image.row_range(height_middle_start, height_middle_end)
        OpenCV::cv::imwrite('hoge.png', cropped_gray_image) # debug

        result_cols = cropped_gray_image.cols - gray_template.cols + 1
        result_rows = cropped_gray_image.rows - gray_template.rows + 1
        result = OpenCV::cv::Mat.new(result_rows, result_cols, OpenCV::cv::CV_32FC1)
        match_method = OpenCV::cv::TM_CCOEFF_NORMED
        OpenCV::cv::match_template(cropped_gray_image, gray_template, result, match_method)

        min_location = OpenCV::cv::Point.new
        max_location = OpenCV::cv::Point.new
        min_val, max_val = OpenCV::cv::min_max_loc(result, min_location, max_location)
        if (match_method == OpenCV::cv::TM_SQDIFF || match_method == OpenCV::cv::TM_SQDIFF_NORMED) && min_val <= THRESHOLD
          match_location = min_location
        elsif max_val >= THRESHOLD
          match_location = max_location
        else
          return nil
        end

        # NOTE: 判定結果をマーキング
        match_location.x += width_middle_start # 正しい位置でマーキングするために検査対象を絞り込んだ部分を足す
        match_location.y += height_middle_start

        OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + template.cols, match_location.y + template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0)
        result_image_path = "#{target_path}-result.png"
        OpenCV::cv::imwrite(result_image_path, image)


        # second_templateとのテンプレートマッチングを実行
        first_match_location = match_location.dup
        # OpenCV::cv::imwrite('hoge.png', first_matched_and_cropped_gray_image) # debug

        result_cols = cropped_gray_image.cols - gray_second_template.cols + 1
        result_rows = cropped_gray_image.rows - gray_second_template.rows + 1
        result = OpenCV::cv::Mat.new(result_rows, result_cols, OpenCV::cv::CV_32FC1)
        OpenCV::cv::match_template(cropped_gray_image, gray_second_template, result, match_method)

        min_location = OpenCV::cv::Point.new
        max_location = OpenCV::cv::Point.new
        min_val, max_val = OpenCV::cv::min_max_loc(result, min_location, max_location)

        if (match_method == OpenCV::cv::TM_SQDIFF || match_method == OpenCV::cv::TM_SQDIFF_NORMED) && min_val <= THRESHOLD
          match_location = min_location
        elsif max_val >= THRESHOLD
          match_location = max_location
        else
          return nil
        end

        match_location.x += first_match_location.x
        match_location.y += first_match_location.y
        OpenCV::cv::rectangle(image, match_location, OpenCV::cv::Point.new(match_location.x + second_template.cols, match_location.y + second_template.rows), OpenCV::cv::Scalar.new(0, 255, 0), 2, 8, 0)
        result_image_path = "#{target_path}-result.png"
        OpenCV::cv::imwrite(result_image_path, image)
      end
    end
  end
end
