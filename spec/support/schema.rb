ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.integer :role, null: false

    t.timestamps
  end
end