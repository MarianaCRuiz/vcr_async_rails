class ReportsController < ApplicationController
  def index
    finding_reports
  end

  def create
    ReportLowPriorityWorker.perform_async
    ReportExampleJob.perform_later
    redirect_to reports_path, notice: 'Estamos processando seu relatório \\o/'
  end

  def destroy
    @report = Report.find_by(id: params[:id])
    address = @report.address
    @report.destroy
    FileUtils.rm_rf(address)
    redirect_to reports_path, notice: 'Relatório excluído com sucesso'
  end

  private

  def finding_reports
    @default_report_path = Rails.configuration.report_generator[:report_default]
    @low_priority_report_path = Rails.configuration.report_generator[:report_low]
    @default_reports = Report.where(report_type: 1) # Dir["#{@default_report_path}/*"]
    @low_priority_reports = Report.where(report_type: 0) # Dir["#{@low_priority_report_path}/*"]
  end
end
