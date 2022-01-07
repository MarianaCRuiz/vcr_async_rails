class ReportContentManager
  REPORT_CATEGORIES = { report_low: { report_type: 0, klass: LowReportGenerator },
                        report_default: { report_type: 1, klass: DefaultReportGenerator },
                        report_critical: { report_type: 2, klass: CriticalReportGenerator } }.freeze
  FILE_CONDITION = { false => 10, true => 100 }.freeze
  attr_accessor :category, :code, :full_address

  def initialize(**params)
    @full_address = params[:full_address]
    @code = params[:code]
    @category = params[:category]
  end

  def create
    written_file = klass.writing_file(full_address, code)
    params = { address: full_address, report_type: report_type,
               report_code: code, file_condition: get_condition(written_file) }
    Report.create!(**params)
  end

  private

  def klass
    REPORT_CATEGORIES[category][:klass]
  end

  def get_condition(written_file)
    FILE_CONDITION[written_file]
  end

  def report_type
    REPORT_CATEGORIES[category][:report_type]
  end
end
