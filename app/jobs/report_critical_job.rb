class ReportCriticalJob < ApplicationJob
  queue_as :critical

  def perform(*_args)
    sleep(Rails.configuration.report_generator[:sleep_time_critical])
    name = Rails.configuration.report_generator[:critical_name]
    FileManager.new(name: name, category: :report_critical).create_file
  end
end
