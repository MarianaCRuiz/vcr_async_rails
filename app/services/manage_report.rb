class ManageReport
  REPORT_CATEGORIES = { report_low: { report_type: 0, klass: FillLowReport },
                        report_default: { report_type: 1, klass: FillDefaultReport } }.freeze
  attr_accessor :full_address, :category, :code

  def initialize(**params)
    @full_address = params[:full_address]
    @code = params[:code]
    @category = params[:category]
  end

  def create
    klass.writing_file(full_address, code)
    Report.create!(address: full_address, report_type: report_type, report_code: code)
  end

  private

  def klass
    REPORT_CATEGORIES[category][:klass]
  end

  def report_type
    REPORT_CATEGORIES[category][:report_type]
  end
end
