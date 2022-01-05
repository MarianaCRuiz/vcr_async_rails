class CreateFolder
  def self.setting_report_folder(category)
    creating_folder(:reports_folder)
    creating_folder(category)
    @report_path
  end

  def self.creating_folder(type_of_report)
    @report_path = Rails.root.join(Rails.configuration.report_generator[type_of_report])
    Dir.mkdir(@report_path) unless File.directory?(@report_path)
  end
end
