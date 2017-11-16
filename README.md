# Streaker

Ruby gem to access Streak's API.

![Streaker on Ninja Warrior](https://media.giphy.com/media/LMfZEPTKKRgJy/giphy.gif)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'streaker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install streaker

## Configuration

```rb
Streak.configure do |config|
  # To find your API key, check out http://www.streak.com/api/#apikey
  config.api_key = 'YOUR_API_KEY_HERE'

  # Provide an identifier for the pipeline(s) you with to access.
  # You can find the pipeline keys keys by adding your api key, then typing
  # inside a console:
  #     $ bin/console
  #     > Streak::Pipeline
  config.pipeline_keys = {
    my_default_pipeline: 'YOUR_PIPELINE_KEY_HERE',
  }

  # Provide an identifier for each "Stage" your boxes can go through.
  # You can find the stage keys by adding a pipeline key, then typing
  # inside a console:
  #
  #     $ bin/console
  #     > pipeline = Streaker.configuration.pipelines.values.first
  #     > stages = Streak::Stage.all(pipeline).instance_variable_get('@values')
  #     > values = stages.map { |value| value.instance_variable_get('@values') }
  #     > values.map { |value| [value[:key].to_i, value[:name]] }.to_h
  config.stage_keys = {
    my_stage: 1042,
  }

  # Provide an identifier for each custom field your boxes can have.
  # You can find all the field keys by adding a pipeline key, then typing
  # inside a console:
  #
  #     $ bin/console
  #     > pipeline_key = Streaker.configuration.pipeline_keys.values.first
  #     > box = Streak::Box.all(pipeline_key).first ; nil
  #     > Streak::FieldValue.all(box.key)
  config.field_keys = {
    my_field: 1043,
  }
end
```

## Usage

Create a box:

```rb
box = Box.create(
  pipeline: :my_default_pipeline,
  name: 'Some box name',
  my_field: 'Some field value',
  …
)
```

Update a box:

```rb
box = Box.new('a_box_key')
box.update(
  my_field: 'A new field value',
  …
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Then, create a `credentials.rb` file with:

```rb
Streaker.configure do |config|
  # To find your API key, check out http://www.streak.com/api/#apikey
  config.api_key = 'YOUR_API_KEY_HERE'
end
```

Then, run `rake spec` to run the tests. You can also run `bin/console` for an
 interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/KissKissBankBank/streaker. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code
of conduct.

## Code of Conduct

Everyone interacting in the Streaker project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/[USERNAME]/streaker/blob/master/CODE_OF_CONDUCT.md).
