# frozen_string_literal: true

require "mysql2"
require "dotenv/load"

ENV["MARIADB_TLS_DISABLE_PEER_VERIFICATION"] = "1"

class Database
  def self.connection
    @connection ||= Mysql2::Client.new(
      host: ENV.fetch("DB_HOST"),
      username: ENV.fetch("DB_USER"),
      password: ENV.fetch("DB_PASSWORD"),
      database: ENV.fetch("DB_NAME")
    )
  end

  def self.execute(sql, params = [])
    with_statement(sql) do |statement|
      statement.execute(*params)&.to_a
    end
  end

  def self.execute_write(sql, params = [])
    with_statement(sql) do |statement|
      statement.execute(*params)

      {
        last_id: statement.last_id,
        affected_rows: statement.affected_rows
      }
    end
  end

  def self.transaction
    client = connection
    client.query("START TRANSACTION")

    begin
      result = yield
      client.query("COMMIT")
      committed = true
      result
    ensure
      client.query("ROLLBACK") unless committed
    end
  end

  def self.close
    @connection&.close
    @connection = nil
  end

  def self.with_statement(sql)
    statement = connection.prepare(sql)
    yield statement
  ensure
    statement&.close
  end
  private_class_method :with_statement
end