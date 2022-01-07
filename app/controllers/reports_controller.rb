class ReportsController < ApplicationController
  before_action :finding_reports, only: :index
  def index; end

  def create
    Report.generator
    redirect_to reports_path, notice: 'Estamos processando seu relatório \\o/'
  end

  def destroy
    @report = Report.find_by(id: params[:id])
    @report.destroy
    ManageReport.destroy_file(@report)
    redirect_to reports_path, notice: 'Relatório excluído com sucesso'
  end

  def destroy_all
    Report.destroy_all
    ManageReport.destroy_all_files
    redirect_to reports_path, notice: 'Relatórios excluídos com sucesso'
  end

  private

  def finding_reports
    @critical_reports = Report.where(report_type: 2)
    @default_reports = Report.where(report_type: 1)
    @low_priority_reports = Report.where(report_type: 0)
    @reports = Report.all
  end
end
