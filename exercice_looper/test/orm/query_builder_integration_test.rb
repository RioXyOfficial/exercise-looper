# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../db/database"
require_relative "../../orm/query_builder"

class QueryBuilderIntegrationTest < Minitest::Test
  def test_insert_stores_the_row_in_mariadb
    Database.execute(<<~SQL)
      CREATE TEMPORARY TABLE orm_insert_test (
        question_id INT AUTO_INCREMENT PRIMARY KEY,
        question_text VARCHAR(255) NOT NULL
      ) ENGINE=InnoDB
    SQL
    table_created = true

    expected_text = "What's Ruby?"
    insert_query = QueryBuilder.insert("orm_insert_test", { question_text: expected_text })
    write_result = Database.execute_write(*insert_query)

    rows = Database.execute("SELECT question_id, question_text FROM orm_insert_test")

    puts "\nWrite result  #{write_result.inspect}"
    puts "Rows stored   #{rows.inspect}"

    assert_equal 1, rows.size

    row = rows.first
    assert_equal expected_text, row.fetch("question_text")
    assert_operator row.fetch("question_id"), :>, 0
    assert_equal 1, write_result.fetch(:affected_rows)
    assert_equal row.fetch("question_id"), write_result.fetch(:last_id)
  ensure
    Database.execute("DROP TEMPORARY TABLE orm_insert_test") if table_created
  end
end