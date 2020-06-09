class AddStateToCookies < ActiveRecord::Migration[5.1]
  def change
    # i know, we should not apply default string for long tables, but this is an empty
    # project and we will be fine :)
    add_column :cookies, :state, :string, default: :created
  end
end
