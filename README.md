# ScopedEnum

Group multiple enum values backed by ActiveRecord::Enum into scopes with ScopedEnum.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scoped_enum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scoped_enum

## Usage

In your ActiveRecord model:

```ruby
class User < ActiveRecord::Base
    scoped_enum :role, { normal: 0, administrator: 1, superuser: 2 }, manager: [:administrator, :superuser]
end
```

Besides stuffs created by a normal enum call, it creates three more things:

1. An ActiveRecord scope with the same name as the enum scope.
```ruby
User.create(name: 'normal', role: :normal)
User.create(name: 'administrator', role: :administrator)
User.create(name: 'superuser', role: :superuser)
User.managers #=> [<User: 'administrator'>, <User: 'superuser'>]
```
2. A class method to return all scopes of an enum.
```ruby
User.role_scopes #=> { manager: { administrator: 1, superuser: 2 } }
```
3. An instance method to check if a record belongs to the scope.
```ruby
u = User.new(role: :normal)
u.manager? #=> false
u.role = :superuser
u.manager? #=> true
```
