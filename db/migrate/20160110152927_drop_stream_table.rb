class DropStreamTable < ActiveRecord::Migration
  def change
    drop_table(:streams)
  end
end
