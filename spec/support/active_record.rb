ActiveRecord::Base.establish_connection(
    adapter:  'postgresql',
    database: 'pg_search_scope_test',
    username: 'postgres',
    host:     'localhost'
)

ActiveRecord::Migration.create_table :users, temporary: true do |t|
  t.string :first_name
  t.string :last_name
  t.string :address
  t.string :email
  t.timestamps null: false
end

ActiveRecord::Migration.create_table :fruits, temporary: true do |t|
  t.string :name
  t.string :description
  t.timestamps null: false
end

class User < ActiveRecord::Base
end
class Fruit < ActiveRecord::Base
end