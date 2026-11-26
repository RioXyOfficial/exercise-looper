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
    Database.execute(*insert_query)

    rows = Database.execute("SELECT question_id, question_text FROM orm_insert_test")

    puts "\nExpected question text  #{expected_text.inspect}"
    puts "Rows stored in MariaDB  #{rows.inspect}"

    assert_equal 1, rows.size
    assert_equal expected_text, rows.first.fetch("question_text")
    assert_operator rows.first.fetch("question_id"), :>, 0
  ensure
    Database.execute("DROP TEMPORARY TABLE orm_insert_test") if table_created
  end
end