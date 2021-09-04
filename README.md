# Seed Dump

Seed Dump is a Rails plugin that adds a rake task named `db:seed:dump`.

It allows you to create seed data files from the existing data in your database.

## Installation

Add it to your Gemfile with:

```ruby
gem 'seed_dump'
```

Or install it by hand:

```sh
$ gem install seed_dump
```

## Examples

### Rake task

Dump all data directly to `db/seeds.rb`:
Dump the data into a separate file for each table. e.g. `db/seeds/users.rb`, `db/seeds/products.rb` ...

```sh
  $ rails db:seed:dump
```

Result:

```ruby:db/seeds.rb
# frozen_string_literal: true

load(Rails.root.join('db','seeds','users.rb'))
load(Rails.root.join('db','seeds','products.rb'))
```

`db/seeds/users.rb`:

```ruby
# frozen_string_literal: true

User.insert_all!([
  { password: "123456", username: "test_1" },
  { password: "234567", username: "test_2" }
])
```

`db/seeds/products.rb`:

```ruby:
# frozen_string_literal: true

Product.insert_all!([
  { category_id: 1, description: "Long Sleeve Shirt", name: "Long Sleeve Shirt" },
  { category_id: 3, description: "Plain White Tee Shirt", name: "Plain T-Shirt" }
])
```

## Options

`config/initializers/seed_dump.rb`:

```ruby
SeedDump.configure do |config|
  config.deny_tables = [/secure_*/, 'credit_cards']
  config.filter_colums = {
    users: {
      email: -> { "#{SecureRandom.uuid}@example.com" },
      token: -> {}
    }
  }
  config.table_class_mappings = {
    admin_staff: 'Admin::Staff'
  }
end
```
