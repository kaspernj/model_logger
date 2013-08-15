require_relative "models/model_logger/log.rb"

module ModelLogger
end

class ActiveRecord::Base
  def self.model_logger
    class_eval do
      logs_const_name = "#{self.name}Log"
      logs_table_name = "#{StringCases.camel_to_snake(logs_const_name)}s"
      
      parent_class_name = self.name
      parent_table_name = StringCases.camel_to_snake(self.name)
      @@parent_table_name = parent_table_name
      
      logs_const = ::Kernel.const_set(logs_const_name, Class.new(ActiveRecord::Base) {
        belongs_to parent_table_name.to_sym
      })
      
      # Extend parent class with method to look up logs.
      has_many :logs, :class_name => logs_const
      
      # Extend parent with method to add new logs easily.
      def log(args)
        logs.create!(args)
      end
      
      # Spawns a migration constant that can be used for migration.
      def self.migration_constant
        table_name = "#{StringCases.camel_to_snake(self.name)}_logs"
        const_name = "AddLogsTo#{self.name}"
        parent_col_name = "#{@@parent_table_name}_id"
        
        ::Kernel.const_set(const_name, Class.new(ActiveRecord::Migration) {
          @@table_name = table_name
          @@parent_col_name = parent_col_name
          
          def up
            unless table_exists?(@@table_name)
              create_table(@@table_name) do |t|
                t.string :title
                t.text :data
                t.integer @@parent_col_name
                t.timestamps
                
                t.index @@parent_col_name
              end
            end
          end
          
          def down
            drop_table(@@table_name) if table_exists?(@@table_name)
          end
        })
      end
      
      # Method to execute migration of logs to the parent class.
      def self.create_model_logger_table!
        ActiveRecord::Migration.run(migration_constant)
      end
      
      # Method to revert migration of logs to the parent class.
      def self.drop_model_logger_table!
        ActiveRecord::Migration.revert(migration_constant)
      end
    end
  end
end
