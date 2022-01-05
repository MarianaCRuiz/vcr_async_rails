class GenerateFile
  def self.building_report_file(name: '', category: '')
    @code = Report.generate_code
    @report_path = CreateFolder.setting_report_folder(category)
    @address = Rails.root.join(@report_path, "#{name}#{@code}.html")
    CreateReports.new(address: @address, code: @code, category: category).create
  end
end
