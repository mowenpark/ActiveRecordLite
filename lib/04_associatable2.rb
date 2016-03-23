require_relative '03_associatable'

module Associatable

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
