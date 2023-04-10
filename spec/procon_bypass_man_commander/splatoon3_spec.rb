RSpec.describe ProconBypassManCommander::Splatoon3 do
  before(:all) do
    `rm ./spec/files/*-result*.png`
  end
  def take_realtime(name)
    time =  Benchmark.realtime { yield }
    puts "#{name}: #{time}"
  end

  it "has a version number" do
    expect(ProconBypassManCommander::Splatoon3::VERSION).not_to be nil
  end

  it do
    take_realtime '1' do
      ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/invisible-target1-sd.png')
    end
    take_realtime '2' do
      ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/invisible-target2-sd.png')
    end
      ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/invisible-target3-sd.png')
    take_realtime '3' do
      ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target1-sd.png')
    end
    take_realtime '4' do
      ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target2-sd.png')
    end
    take_realtime '5' do
      ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target3-sd.png')
    end
    take_realtime '6' do
      ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target4-sd.png')
    end
      ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target5-sd.png')
      ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target6-sd.png')
  end

  it do
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target1-sd.png')
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target2-sd.png')
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target3-sd.png')
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target4-sd.png')

    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/invisible-target1-sd.png')
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/invisible-target2-sd.png')

  end
end
