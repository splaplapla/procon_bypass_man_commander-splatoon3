require 'spec_helper'

RSpec.describe ProconBypassManCommander::Splatoon3::EnemyTargetDetector do
  before(:all) do
    system "rm ./spec/files/**/*result.png"
  end

  describe 'detect?' do
    context 'when no_targets' do
      let(:skip_table) do
        {
          'invisible-target4-sd.png' => '謎',
        }
      end
      let(:expected_value) { false }

      Dir.glob('./spec/files/no_targets/*.png') do |path|
        next if path.end_with?('result.png')

        it "there is no target on #{path}" do
          if(reason = skip_table[Pathname.new(path).basename.to_s])
            described_class.detect?(path, debug: true)
            skip reason
          end

          actual = described_class.detect?(path, debug: false)
          if expected_value != actual
            described_class.detect?(path, debug: true)
          end
          expect(actual).to eq(expected_value)
        end
      end
    end

    context 'when has_targets' do
      let(:skip_table) do
        {
          'name_00377.png' => '背景と色がかぶっているので厳しそう',
          'name_00224.png' => 'これは判定できてほしい',
        }
      end
      let(:expected_value) { true }

      Dir.glob('./spec/files/has_targets/shoorter/*.png') do |path|
        next if path.end_with?('result.png')

        it "there is a target on #{path}" do
          if(reason = skip_table[Pathname.new(path).basename.to_s])
            skip reason
          end

          actual = described_class.detect?(path, debug: true)
          expect(actual).to eq(expected_value)
        end
      end
    end
  end
end
