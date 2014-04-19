class RemoveColumns < ActiveRecord::Migration
    def self.up
        remove_column :users, :isadmin
    end

    def self.down
        add_column :users, :isadmin, :string
    end
end
