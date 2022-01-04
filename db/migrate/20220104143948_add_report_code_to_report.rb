class AddReportCodeToReport < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :report_code, :string
    add_index :reports, :report_code, unique: true
  end
end
