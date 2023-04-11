require 'benchmark/ips'
require "procon_bypass_man_commander/splatoon3"

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("HD has_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetectorHD.detect?('./spec/files/hd/has_targets/shooter/0.png')
  }
  x.report("HD no_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetectorHD.detect?('./spec/files/hd/no_targets/d.png')
  }
  x.report("HD Liter has_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetectorHD.detect?('./spec/files/hd/liter/has_targets/0.png')
  }
  x.report("HD Liter no_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetectorHD.detect?('./spec/files/hd/liter/no_targets/1.png')
  }
  x.report("360p has_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetector360p.detect?('./spec/files/360p/has_targets/shooter/name_00743.png')
  }
  x.report("360p no_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetector360p.detect?('./spec/files/360p/no_targets/0.png')
  }
  x.compare!
end
