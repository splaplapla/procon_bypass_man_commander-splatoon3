require 'benchmark/ips'
require "procon_bypass_man_commander/splatoon3"

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("has_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetector.detect?('./spec/files/has_targets/shoorter/name_00743.png')
  }
  x.report("no_targets") {
    ProconBypassManCommander::Splatoon3::EnemyTargetDetector.detect?('./spec/files/no_targets/0.png')
  }
  x.compare!
end
