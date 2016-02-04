require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    "#{class_name.downcase}s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      :foreign_key => "#{name}_id".to_sym,
      :class_name => name.to_s.singularize.camelcase,
      :primary_key => :id
    }
    defaults.merge!(options)
    @foreign_key = defaults[:foreign_key]
    @primary_key = defaults[:primary_key]
    @class_name = defaults[:class_name]
    # debugger
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    # debugger
    defaults = {
      :foreign_key => "#{self_class_name}_id".downcase.to_sym,
      :class_name => name.to_s.singularize.camelcase,
      :primary_key => :id
    }
    # debugger
    defaults.merge!(options)
    # debugger
    @foreign_key = defaults[:foreign_key]
    @primary_key = defaults[:primary_key]
    @class_name = defaults[:class_name]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    # debugger
    define_method(name) do
      # options.model_class
      # debugger
      options.model_class.where(options.primary_key => self.send(options.foreign_key)).first
    end
  end

  def has_many(name, options = {})
    # HasManyOptions.new(name, options)
    # debugger
    options = HasManyOptions.new(name, self.name, options)

    define_method(name) do
      # options.model_class
      # debugger
      options.model_class.where(options.foreign_key => self.send(options.primary_key))
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject

  extend Associatable

end
