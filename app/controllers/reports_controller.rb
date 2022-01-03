class ReportsController < ApplicationController
  before_action :finding_paths, only: :destroy_all
  before_action :finding_reports, only: :index
  def index; end

  def create
    ReportExampleJob.perform_later
    ReportLowPriorityWorker.perform_async
    redirect_to reports_path, notice: 'Estamos processando seu relatório \\o/'
  end

  def destroy
    @report = Report.find_by(id: params[:id])
    address = @report.address
    @report.destroy
    FileUtils.rm_rf(address)
    redirect_to reports_path, notice: 'Relatório excluído com sucesso'
  end

  def destroy_all
    Report.destroy_all
    FileUtils.rm_rf(Dir[Rails.root.join("#{@default_report_path}/*")])
    FileUtils.rm_rf(Dir[Rails.root.join("#{@low_priority_report_path}/*")])
    redirect_to reports_path, notice: 'Relatórios excluídos com sucesso'
  end

  private

  def finding_paths
    @default_report_path = Rails.configuration.report_generator[:report_default]
    @low_priority_report_path = Rails.configuration.report_generator[:report_low]
  end

  def finding_reports
    @default_reports = Report.where(report_type: 1) # Dir["#{@default_report_path}/*"]
    @low_priority_reports = Report.where(report_type: 0) # Dir["#{@low_priority_report_path}/*"]
    @reports = Report.all
  end
end
