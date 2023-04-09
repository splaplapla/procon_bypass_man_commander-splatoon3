# ProconBypassManCommander::Splatoon3

* template matching
* This gem is used by https://github.com/splaplapla/procon_bypass_man_commander

## Installation
require opencv!!!!!

```
brew install opencv@3 cmake python3
ln -s "$(which python3)" /usr/local/bin/python
export LDFLAGS="-L/opt/homebrew/opt/opencv@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/opencv@3/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/opencv@3/lib/pkgconfig"
gem i ropencv
```

Add this line to your application's Gemfile:

```ruby
gem 'procon_bypass_man_commander-splatoon3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install procon_bypass_man_commander-splatoon3

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/procon_bypass_man_commander-splatoon3.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## TODO
* 解像度を上げると検出率と負荷はどう変化するのか？
  * 少なくとも解析対象の画像は小さい方が負荷は低い
  * 解像度のパターン
      * 低: 640x360
      * 中: 1280x720
      * 高: 1920x1080
