class ReportExampleJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    sleep(Rails.configuration.report_generator[:sleep_time_reports])
    name = Rails.configuration.report_generator[:default_name]
    FileManager.new(name: name, category: :report_default).create_file
  end
end
