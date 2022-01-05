class ReportExampleJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    sleep(Rails.configuration.report_generator[:sleep_time_reports])
    GenerateFile.building_report_file(name: 'reportexample', category: :report_default)
  end
end
