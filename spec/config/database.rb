# frozen_string_literal: true

RSpec.configure do |config|
  config.before :each do
    reset_database
    ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
  end
end

def truncate_tables
  silenced { PgTasks.truncate_tables }
end

def reset_database
  truncate_tables
  silenced { PgTasks.data_restore Rails.root.join('db', 'seeds.pgbin') }
end

def with_disabled_triggers
  db = ActiveRecord::Base.connection
  db.execute 'SET session_replication_role = REPLICA;'
  yield
  db.execute 'SET session_replication_role = DEFAULT;'
end

# NOTE: only needed to supress 'PgTasks' output
require 'stringio'
def silenced
  previous_stdout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = previous_stdout
end
