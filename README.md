# Freshdesk::Client

This gem is designed to communicate with the Freshdesk API through instantiation of the main class Freshdesk::Client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'freshdesk-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install freshdesk-client

## Usage

Authentication:

```ruby
client = Freshdesk::Client.new(subdomain, email, password)
```

To retrieve all users and companies:

```
users = client.users
companies = client.companies
```

To add, delete and update users:

```ruby
create_user(user_data)
update_user(id, user_data, options)
delete_user(id)
```

To retrieve user custom fields:

```ruby
custom_fields = client.custom_fields
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/freshdesk-client.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
