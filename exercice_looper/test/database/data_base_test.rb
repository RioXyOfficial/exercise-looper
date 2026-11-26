require "minitest/autorun"
require_relative "../../db/database"

class DatabaseTest < Minitest::Test
  def test_transaction_rolls_back_when_second_insert_fails
    Database.execute(<<~SQL)
      CREATE TEMPORARY TABLE orm_transaction_test (
        id INT PRIMARY KEY
      ) ENGINE=InnoDB
    SQL

    error = assert_raises(Mysql2::Error) do
      Database.transaction do
        connection_id = current_connection_id

        Database.execute("INSERT INTO orm_transaction_test (id) VALUES (?)", [1])

        assert_equal connection_id, current_connection_id

        Database.execute("INSERT INTO orm_transaction_test (id) VALUES (?)", [1])
      end
    end

    assert_equal 1062, error.error_number # Clé dupliquée
    assert_empty Database.execute("SELECT id FROM orm_transaction_test")
  ensure
    Database.execute("DROP TEMPORARY TABLE IF EXISTS orm_transaction_test")
  end

  private

  def current_connection_id
    Database.execute("SELECT CONNECTION_ID() AS connection_id")
            .first.fetch("connection_id")
  end
end