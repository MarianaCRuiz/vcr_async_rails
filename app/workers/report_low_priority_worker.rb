class ReportLowPriorityWorker
  include Sidekiq::Worker
  queue_as :low

  def perform(*_args)
    sleep(Rails.configuration.report_generator[:sleep_time_low])
    name = Rails.configuration.report_generator[:low_name]
    ManageFile.new(name: name, category: :report_low).create_file
  end
end
