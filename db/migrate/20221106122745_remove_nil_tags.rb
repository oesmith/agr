class RemoveNilTags < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      UPDATE feeds
        SET tag = ""
        WHERE tag is NULL;
    SQL
  end

  def down
  end
end
