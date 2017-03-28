class ChangeTypesForNews < ActiveRecord::Migration[5.0]
  def change
     change_column :news, :Title, :text
     change_column :news, :Content, :text
     change_column :news, :Url, :text
     change_column :news, :Source, :text
     change_column :news, :TermsOfUse, :text
  end
end
