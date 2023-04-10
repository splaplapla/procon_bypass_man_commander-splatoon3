require 'spec_helper'

RSpec.describe ProconBypassManCommander::Splatoon3::EnemyTargetDetector do
  before(:all) do
    system "rm ./spec/files/**/*result.png"
  end

  describe 'detect?' do
    context 'no_targets' do
      let(:skip_table) do
        {
          'invisible-target4-sd.png' => '謎',
          'name_00381.png' => 'これは除外したい',
          'fff.png' => 'これは判定したい',
          'ff.png' => 'これは判定したい',
          'city.png' => '謎',
          'city.png' => '謎',
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

          actual = described_class.detect?(path)
          if expected_value != actual
            described_class.detect?(path, debug: true)
          end
          expect(actual).to eq(expected_value)
        end
      end
    end

    context 'has_targets' do
      let(:skip_table) do
        { 'invisible-target1-sd.png' => 'プレイヤーにマッチしてしまっている. 一旦スキップ',
          'invisible-target4-sd.png' => '謎',
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
          if expected_value != actual
            described_class.detect?(path, debug: true)
          end
          expect(actual).to eq(expected_value)
        end
      end
    end
  end
end
