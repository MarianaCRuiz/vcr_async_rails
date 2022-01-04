class ReportExampleJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    sleep(Rails.configuration.report_generator[:sleep_time_reports])
    building_report_file
    Report.create!(address: @report_address, report_type: 1, report_code: @code)
  end

  def arraging_report_folder
    ReportFolder.creating_reports_folder
    @report_address = ReportFolder.setting_default_report_folder(@code)
  end

  def building_report_file
    @code = Report.generate_code
    arraging_report_folder
    writting_report
  end

  def writting_report
    @data_typicode = Faraday.get('https://jsonplaceholder.typicode.com/posts/2')
    @out_file = File.new(@report_address, 'w')
    @out_file.puts("<p>Your ReportExample Here - code: <b>#{@code}</b></p>")
    @out_file.puts(JSON.parse(@data_typicode.body, symbolize_names: true))
    @out_file.close
  end
end
