module ProconBypassManCommander
  module Splatoon3
    class EnemyTargetDetector
      # @return [Boolean]
      def self.detect?(target_path, debug: false)
        ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: target_path, debug: debug)
      end
    end
  end
end
