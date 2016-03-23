#Active Record Lite

An object relational mapping (ORM) system that translates between SQL records and Ruby objects.

### `::find` and `::all`

`find` and `all` are used to fetch records from the DB. Active Record Lite is able to infer from the
class name `Human` that the associated table is `humans`.

```ruby
# return an array of Human objects, one for each row in the
# humans table
Human.all

# lookup the Human with primary key (id) 101
Human.find(101)
```

### `::where` queries

Active Record Lite lets you dynamically generate complex queries query without SQL fragments.

```ruby
# return an array of humans with the first name "Matt" from house 1.
Human.where(fname: 'Matt', house_id: 1)
# Executes:
#   SELECT *
#     FROM humans
#    WHERE humans.fname = 'Matt' AND humans.house_id = 1
```

### `AssocOptions`

`BelongsToOptions` and `HasManyOptions` classes extend `AssocOptions` parent to store the essential
information needed to define the `belongs_to` and `has_many` associations:

* `#foreign_key`
* `#class_name`
* `#primary_key`


### `belongs_to` and `has_many`

These methods take in the association name and an options hash, building a `BelongsToOptions` or `HasManyOptions` object.

* `send` passes method to get the value of the foreign key.
* `model_class` retrieves the target model class.
* `where` selects those models where the `primary_key` column is
  equal to the foreign key value.
* Calls `first` (since there should be only one such item).
