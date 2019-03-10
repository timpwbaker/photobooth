class AddShootImages < ActiveRecord::Migration[5.1]
  def change
    add_column :shoots, :image1, :string
    add_column :shoots, :image2, :string
    add_column :shoots, :image3, :string
    add_column :shoots, :image4, :string
  end
end
