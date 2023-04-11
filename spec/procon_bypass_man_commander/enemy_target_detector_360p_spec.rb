require 'spec_helper'

RSpec.describe ProconBypassManCommander::Splatoon3::EnemyTargetDetector360p do
  before(:all) do
    system "rm -f ./spec/files/**/*result.png"
  end

  describe 'detect?' do
    context 'when no targets' do
      let(:ignore_table) do
        {
          'invisible-target4-sd.png' => '謎',
        }
      end
      let(:expected_value) { false }

      raise('!!!!!!!!') if Dir.glob('./spec/files/360p/no_targets/*.png').empty?
      Dir.glob('./spec/files/360p/no_targets/*.png') do |path|
        next if path.end_with?('result.png')

        it "there is no target on #{path}" do
          if(reason = ignore_table[Pathname.new(path).basename.to_s])
            described_class.detect?(path, debug: true)
            skip reason
          end

          actual = described_class.detect?(path, debug: false) do |ok_or_ng, matched_results|
            puts "correlation_values: #{matched_results.map(&:correlation_value)}"
          end
          if expected_value != actual
            described_class.detect?(path, debug: true)
          end
          expect(actual).to eq(expected_value)
        end
      end
    end

    context 'when has targets' do
      let(:ignore_table) do
        {
          'name_00224.png' => 'アニメーションの途中っぽいのでしょうがなさそう',
        }
      end
      let(:expected_value) { true }

      Dir.glob('./spec/files/360p/has_targets/shooter/*.png') do |path|
        next if path.end_with?('result.png')

        # TODO: 'part_matchingの方が精度がいいのでskip'
        # context 'single mode' do
        #   it "there is a target on #{path}" do
        #     if(reason = ignore_table[Pathname.new(path).basename.to_s])
        #       skip reason
        #     end
        #
        #     actual = described_class.detect?(path, debug: true, mode: :single_matching) do |ok_or_ng, matched_results|
        #       puts "correlation_values: #{matched_results.map(&:correlation_value)}"
        #     end
        #     expect(actual).to eq(expected_value)
        #   end
        # end

        context 'part_matching mode' do
          it "there is a target on #{path}" do
            if(reason = ignore_table[Pathname.new(path).basename.to_s])
              skip reason
            end

            actual = described_class.detect?(path, debug: true) do |ok_or_ng, matched_results|
              puts "correlation_values: #{matched_results.map(&:correlation_value)}"
            end
            expect(actual).to eq(expected_value)
          end
        end
      end
    end
  end
end
