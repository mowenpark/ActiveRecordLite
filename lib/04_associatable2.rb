require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      result = self.send(through_name).send(source_name)
      if result
        return result
      else
        {}
      end
    end
  end
end
