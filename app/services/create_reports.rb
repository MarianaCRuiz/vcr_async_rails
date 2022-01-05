class CreateReports
  REPORT_CATEGORIES = { report_low: { report_type: 0, klass: FillLowReport },
                        report_default: { report_type: 1, klass: FillDefaultReport } }.freeze

  attr_accessor :address, :code, :category

  def initialize(**params)
    @address = params[:address]
    @code = params[:code]
    @category = params[:category]
  end

  def create
    klass.writing_file(address, code)
    Report.create!(address: address, report_type: report_type, report_code: code)
  end

  private

  def klass
    REPORT_CATEGORIES[category][:klass]
  end

  def report_type
    REPORT_CATEGORIES[category][:report_type]
  end
end
