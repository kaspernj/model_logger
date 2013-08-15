class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.timestamps
    end
    
    puts "Calling model logger."
    User.create_model_logger_table!
  end
  
  def down
    drop_table :users
    User.drop_model_logger_table!
  end
end
