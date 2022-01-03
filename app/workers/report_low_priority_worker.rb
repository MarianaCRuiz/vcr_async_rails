class ReportLowPriorityWorker
  include Sidekiq::Worker
  # sidekiq_options queue: 'low'
  queue_as :low

  def perform(*_args)
    sleep(Rails.configuration.report_generator[:sleep_time_low])
    setting_report_folder
    building_report_file
    Report.create!(address: @report_address, report_type: 0)
  end

  def building_report_file
    code = (0...8).map { rand(65..90).chr }.join
    @report_address = Rails.root.join(@report_address_folder, "lowpriorityreport#{code}.html") # Time.current
    @out_file = File.new(@report_address, 'w')
    @out_file.puts("<p>Your Low Priority Report Here - code: <b>#{code}</b></p>")
    @out_file.puts('<p>e-Book: Guia de Gems OneBitCode :)</p>')
    @out_file.close
  end

  def setting_report_folder
    @report_address_folder = Rails.configuration.report_generator[:report_low]
    report_folder = Rails.root.join(@report_address_folder)
    Dir.mkdir(report_folder) unless File.directory?(report_folder)
  end
end
