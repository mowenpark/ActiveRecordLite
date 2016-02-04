require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @contents ||= DBConnection.execute2(<<-SQL)
          SELECT
            *
          FROM
            '#{table_name}'
          SQL
    @contents[0].map { |e| e.to_sym }
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) do
        attributes[column]
      end
      define_method("#{column}=") do |value|
        attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= "#{self}".tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
    SELECT
    #{table_name}.*
    FROM
    #{table_name}
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
    # debugger
    results.map do |result|
      new(result)
    end
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL)
    SELECT
    #{table_name}.*
    FROM
    #{table_name}
    WHERE
    #{table_name}.id = #{id}
    SQL
    # debugger
    result.empty? ? nil : new(result[0])
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      new_name = attr_name.to_sym
      # debugger
      if self.class.columns.include?(new_name)
        self.send("#{attr_name}=".to_sym, value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |e| self.send(e) }
  end

  def insert
    col_names = self.class.columns[1..-1].join(", ")
    # question_marks = ["?"] * self.class.columns.count
    # question_marks = question_marks.join(", ")
    attr_val = attribute_values[1..-1]
    # debugger
    DBConnection.execute(<<-SQL)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{attr_val.map { |e| "'#{e}'" }.join(", ")})
    SQL
    self.id = self.class.all.last.id
  end

  def update
    set_cols = self.class.columns[1..-1].map { |e| "#{e} = ?" }.join(", ")
    attr_val = attribute_values[1..-1]
    # debugger
    DBConnection.execute(<<-SQL, attr_val)
    UPDATE
      #{self.class.table_name}
    SET
      #{set_cols}
    WHERE
      id = #{self.id}
    SQL
  end

  def save
    if self.id.nil?
      self.insert
    else
      self.update
    end
  end
end
