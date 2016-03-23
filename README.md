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
