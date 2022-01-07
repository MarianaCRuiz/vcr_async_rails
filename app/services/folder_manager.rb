class FolderManager
  def self.setting_report_folder(category)
    creating_folder(:reports_folder)
    creating_folder(category)
    @report_path
  end

  def self.creating_folder(category)
    @report_path = Rails.root.join(Rails.configuration.report_generator[category])
    Dir.mkdir(@report_path) unless File.directory?(@report_path)
  end
end
