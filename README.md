# ActionHandle

This gem allows distributed locking with data for actions that are asynchoronous, distributed or simply have various state dependent rules.

## Usage examples

### ActiveJob conflicts

Let's say we have some resource managed by a handle
```ruby
class ResourceHandle < ActionHandle::Base; end
```

And two async jobs with different priorities
```ruby
class NiceToHaveJob
  def perform
    handle = ResourceHandle.new('resource_name', 'nice')

    return unless handle.create

    # execution code

    handle.expire
  end
end

class ImportantJob
  def perform
    handle = ResourceHandle.new('resource_name', 'vip')

    return if handle.value == 'vip'

    handle.claim # ignores current owner

    # execution code

    handle.expire
  end
end
```

`NiceToHaveJob` will only perform on free resource, while `ImportantJob` will always perform unless another `vip` is already performing.

### Not so serious story time example
Let's say we have a room and a few users who try to book it

First we define a room handle
```ruby
class RoomHandle < ActionHandle::Base
  prefix :room
  ttl 30.minutes
end
```

Then we create a handle with room number and user
```ruby
RoomHandle.create(101, 'Tom', 15.minutes)
#=> true
```

Tom booked this room with a ttl of an hour. Another user tries to do the same

```ruby
handle = RoomHandle.new(101, 'Jack')
handle.create
#=> false

handle.value
#=> 'Tom'
```

Jack fails to book the room and sees that Tom is using it so decides to try later. Most of ttl has passed but Tom is still in the room and extends his handle (a pretty dick move considering Jack is waiting)

```ruby
RoomHandle.renew(101, 'Tom', 1.hour)
#=> true
```

More than a standart ttl has passed and Jack tries to book again

```ruby
RoomHandle.create(101, 'Jack')
#=> false
```

Jack fails to book the room and stays angry on Tom for taking too long and contacts managament. Meaniwhile Tom is done with his things and leaves the room.

```ruby
RoomHandle.expire(101, 'Tom')
#=> true
```

Managament decides to excersise their power and kick Tom out, but sees that no one is using the room

```ruby
RoomHandle.new(101).taken?
#=> false
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action-handle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action-handle

## Configuration

```ruby
ActionHandle.configure do
  # simply current redis
  adapter :redis

  # redis with pool
  adapter :redis
  redis_pool ConnectionPool.new(size: 5, timeout: 3) { Redis.new }

  # rails cache
  adapter :cache

  # adapters directly (for ex. custom adapters)
  adapter Adapters::RedisPool.new(
    ConnectionPool.new(size: 5, timeout: 3) { Redis.new }
  )
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interaction prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rbviz/action-handle. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActionHandle project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/action-handle/blob/master/CODE_OF_CONDUCT.md).
