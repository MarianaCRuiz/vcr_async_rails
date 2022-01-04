class ReportLowPriorityWorker
  include Sidekiq::Worker
  # sidekiq_options queue: 'low'
  queue_as :low

  def perform(*_args)
    sleep(Rails.configuration.report_generator[:sleep_time_low])
    building_report_file
    Report.create!(address: @report_low_address, report_type: 0, report_code: @code)
  end

  def building_report_file
    @code = Report.generate_code
    arraging_report_folder
    writting_report
  end

  def arraging_report_folder
    ReportFolder.creating_general_reports_folder
    @report_low_address = ReportFolder.setting_low_report_folder(@code)
  end

  def writting_report
    @out_file = File.new(@report_low_address, 'w')
    @out_file.puts("<p>Your Low Priority Report Here - code: <b>#{@code}</b></p>")
    @out_file.puts('<p>e-Book: Guia de Gems OneBitCode :)</p>')
    @out_file.close
  end
end
