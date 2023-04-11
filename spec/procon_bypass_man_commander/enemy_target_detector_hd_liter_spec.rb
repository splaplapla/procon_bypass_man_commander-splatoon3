require 'spec_helper'

RSpec.describe ProconBypassManCommander::Splatoon3::EnemyTargetDetectorHDLiter do
  before(:all) do
    system "rm -f ./spec/files/**/*result.png"
  end

  describe 'detect?' do
    context 'when no targets' do
      let(:ignore_table) do
        {
          'd.png' => 'これは直したい',
        }
      end
      let(:expected_value) { false }

      raise('!!!!!!!!') if Dir.glob('./spec/files/hd/liter/no_targets/*.png').empty?
      Dir.glob('./spec/files/hd/liter/no_targets/*.png') do |path|
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
        }
      end
      let(:expected_value) { true }

      Dir.glob('./spec/files/hd/liter/has_targets/*.png') do |path|
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
