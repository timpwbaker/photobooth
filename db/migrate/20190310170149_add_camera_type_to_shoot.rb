class AddCameraTypeToShoot < ActiveRecord::Migration[5.1]
  def change
    add_column :shoots, :camera_type, :string
  end
end
