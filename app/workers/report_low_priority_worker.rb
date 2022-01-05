class ReportLowPriorityWorker
  include Sidekiq::Worker
  queue_as :low

  def perform(*_args)
    sleep(Rails.configuration.report_generator[:sleep_time_low])
    GenerateFile.building_report_file(name: 'lowpriorityreport', category: :report_low)
  end
end
