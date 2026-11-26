# frozen_string_literal: true

require 'mysql2'
require 'dotenv/load'

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
    statement = connection.prepare(sql)
    statement.execute(*params)&.to_a
  ensure
    statement&.close
  end

  def self.transaction
    client = connection
    client.query("START TRANSACTION")
    committed = false

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
end