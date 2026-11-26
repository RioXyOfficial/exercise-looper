# frozen_string_literal: true

class QueryBuilder
  def self.insert(table, attributes)
    columns = attributes.keys.join(", ")
    placeholders = Array.new(attributes.size, "?").join(", ")

    sql = "INSERT INTO #{table} (#{columns}) VALUES (#{placeholders})"
    [sql, attributes.values]
  end
end
