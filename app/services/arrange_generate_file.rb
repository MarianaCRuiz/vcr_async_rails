class ArrangeGenerateFile
  attr_accessor :full_address, :category, :code, :name

  def initialize(name: 'reportexample', category: :report_default)
    @name = name
    @category = category
    self.code = @code = Report.generate_code
    @report_path = CreateFolder.setting_report_folder(category)
    self.full_address = @full_address = Rails.root.join(@report_path, "#{name}#{@code}.html")
  end

  def create_file
    ManageReport.new(full_address: full_address, code: code, category: category, name: name).create
  end
end
