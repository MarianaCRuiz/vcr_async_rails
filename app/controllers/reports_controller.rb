class ReportsController < ApplicationController
  before_action :find_reports, only: :index
  before_action :find_report, only: :destroy

  def index; end

  def create
    AsyncReportGenerator.create
    redirect_to reports_path, notice: 'Estamos processando seu relatório \\o/'
  end

  def destroy
    @report.destroy
    FileManager.destroy_file(@report)
    redirect_to reports_path, notice: 'Relatório excluído com sucesso'
  end

  def destroy_all
    Report.destroy_all
    FileManager.destroy_all_files
    redirect_to reports_path, notice: 'Relatórios excluídos com sucesso'
  end

  private

  def find_reports
    @critical_reports = Report.where(report_type: 2)
    @default_reports = Report.where(report_type: 1)
    @low_priority_reports = Report.where(report_type: 0)
    @reports = Report.all
  end

  def find_report
    @report = Report.find_by(id: params[:id])
  end
end
