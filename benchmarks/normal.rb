require 'benchmark/ips'
require "procon_bypass_man_commander/splatoon3"

hd_has_targets = OpenCV::cv::imread('./spec/files/hd/has_targets/shooter/0.png', OpenCV::cv::IMREAD_COLOR)
hd_no_targets = OpenCV::cv::imread('./spec/files/hd/no_targets/d.png', OpenCV::cv::IMREAD_COLOR)
hd_liter_has_targets = OpenCV::cv::imread('./spec/files/hd/liter/has_targets/0.png', OpenCV::cv::IMREAD_COLOR)
hd_liter_no_targets = OpenCV::cv::imread('./spec/files/hd/liter/no_targets/1.png', OpenCV::cv::IMREAD_COLOR)
x360p_has_targets = OpenCV::cv::imread('./spec/files/360p/has_targets/shooter/name_00743.png', OpenCV::cv::IMREAD_COLOR)
x360p_no_targets = OpenCV::cv::imread('./spec/files/360p/no_targets/0.png', OpenCV::cv::IMREAD_COLOR)

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("HD has_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetectorHD.detect?(hd_has_targets)
  }
  x.report("HD no_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetectorHD.detect?(hd_no_targets)
  }
  x.report("HD Liter has_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetectorHD.detect?(hd_liter_has_targets)
  }
  x.report("HD Liter no_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetectorHD.detect?(hd_liter_no_targets)
  }
  x.report("360p has_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetector360p.detect?(x360p_has_targets)
  }
  x.report("360p no_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetector360p.detect?(x360p_no_targets)
  }
  x.compare!
end
