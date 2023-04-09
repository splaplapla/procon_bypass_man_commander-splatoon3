RSpec.describe ProconBypassManCommander::Splatoon3 do
  it "has a version number" do
    expect(ProconBypassManCommander::Splatoon3::VERSION).not_to be nil
  end

  it do
    binding.pry
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/invisible-target1-sd.png')
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/invisible-target2-sd.png')

    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target1-sd.png')
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target2-sd.png')
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target3-sd.png')
    ProconBypassManCommander::Splatoon3::TemplateMatcher.match(target_path: './spec/files/shoorter-visible-target4-sd.png')
'./lib/procon_bypass_man_commander/splatoon3/assets/template-sd.png'

  end
end
