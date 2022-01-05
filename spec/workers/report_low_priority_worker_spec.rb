require 'rails_helper'

describe ReportLowPriorityWorker do
  it 'worker fake' do
    Sidekiq::Testing.fake!

    expect { ReportLowPriorityWorker.perform_async }.to change(ReportLowPriorityWorker.jobs, :size).by(1)
    expect(ReportLowPriorityWorker.new).to respond_to(:perform)
  end

  it 'worker inline' do
    Sidekiq::Testing.inline!
    path = Rails.configuration.report_generator[:report_low]
    before_generator = Dir[Rails.root.join("#{path}/*")].length
    ReportLowPriorityWorker.perform_async

    expect(Dir[Rails.root.join("#{path}/*")].length).to eq(before_generator + 1)
  end

  it 'queue' do
    expect(ReportLowPriorityWorker.get_sidekiq_options['queue']).to eq('low')
  end

  it 'content' do
    Sidekiq::Testing.inline!
    ReportLowPriorityWorker.perform_async
    data = File.open(Report.last.address)
    lines = data.readlines.map(&:chomp)
    data.close

    expect(lines[0]).to match(/Your Low Priority Report Here/)
  end
end
