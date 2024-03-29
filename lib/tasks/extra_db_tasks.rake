# Credit for this task comes from here. No license or copyright notice so assumed 
# legitmate to include this. 
namespace :db do
  namespace :fixtures do
    desc 'Create YAML test fixtures from data in an existing database.  
    Defaults to development database.  Set RAILS_ENV to override.'
    task :dump => :environment do
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_info"]
      ActiveRecord::Base.establish_connection(:development)
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"
        File.open("#{RAILS_ROOT}/test/fixtures/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end

  end
  task :recreate => :environment do
    ActiveRecord::Base.establish_connection(:development)
    ActiveRecord::Base.connection.execute "DROP DATABASE xchain"
    ActiveRecord::Base.connection.execute "CREATE DATABASE xchain"
    ActiveRecord::Base.connection.execute "USE xchain"
  end
  task :refresh => ['db:recreate', 'db:migrate', 'db:fixtures:load']

end



