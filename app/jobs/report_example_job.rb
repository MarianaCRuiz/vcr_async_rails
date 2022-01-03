class ReportExampleJob < ApplicationJob
  queue_as :reports

  def perform(*_args)
    sleep(Rails.configuration.report_generator[:sleep_time_reports])
    creating_reports_folder
    setting_default_report_folder
    building_report_file
    Report.create!(address: @report_address, report_type: 1)
  end

  def building_report_file
    @data_typicode = Faraday.get('https://jsonplaceholder.typicode.com/posts/2')
    @out_file = File.new(@report_address, 'w')
    @out_file.puts("<p>Your ReportExample Here - code: <b>#{@code}</b></p>")
    @out_file.puts(JSON.parse(@data_typicode.body, symbolize_names: true))
    @out_file.close
  end

  def creating_reports_folder
    all_reports_folder = Rails.configuration.report_generator[:reports_folder]
    Dir.mkdir(all_reports_folder) unless File.directory?(all_reports_folder)
  end

  def setting_default_report_folder
    @report_address_folder = Rails.configuration.report_generator[:report_default]
    report_folder = Rails.root.join(@report_address_folder)
    Dir.mkdir(report_folder) unless File.directory?(report_folder)
    @code = (0...8).map { rand(65..90).chr }.join
    @report_address = Rails.root.join(@report_address_folder, "reportexample#{@code}.html") # Time.current
  end
end
