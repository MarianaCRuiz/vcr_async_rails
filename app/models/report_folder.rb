class ReportFolder
  def self.creating_reports_folder
    all_reports_folder = Rails.configuration.report_generator[:reports_folder]
    Dir.mkdir(all_reports_folder) unless File.directory?(all_reports_folder)
  end

  def self.setting_default_report_folder(code)
    creating_folder(:report_default)
    @report_default_address = Rails.root.join(@report_address_folder, "reportexample#{code}.html")
  end

  def self.setting_low_report_folder(code)
    creating_folder(:report_low)
    @report_low_address = Rails.root.join(@report_address_folder, "lowpriorityreport#{code}.html")
  end

  def self.creating_folder(type_of_report)
    @report_address_folder = Rails.configuration.report_generator[type_of_report]
    report_folder = Rails.root.join(@report_address_folder)
    Dir.mkdir(report_folder) unless File.directory?(report_folder)
  end
end
