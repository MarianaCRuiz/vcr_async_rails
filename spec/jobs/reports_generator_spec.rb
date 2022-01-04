require 'rails_helper'

describe ReportExampleJob do
  before(:each) { ActiveJob::Base.queue_adapter = :test }

  it 'verify if queued' do
    VCR.use_cassette('report_example') do
      expect { ReportExampleJob.perform_later }.to have_enqueued_job.on_queue('default')
    end
  end

  it 'queue amount' do
    VCR.use_cassette('report_example') do
      ReportExampleJob.perform_later

      expect(ReportExampleJob).to have_been_enqueued.exactly(:once)
    end
  end

  it 'queue performed job' do
    VCR.use_cassette('report_example') do
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      before_generator = Dir[Rails.root.join('spec/reports/default/*')].length

      expect { ReportExampleJob.perform_later }.to have_performed_job.on_queue('default')
      expect(Dir[Rails.root.join('spec/reports/default/*')].length).to eq(before_generator + 1)
    end
  end

  it 'content' do
    VCR.use_cassette('report_example') do
      ReportExampleJob.perform_now
      data = File.open(Report.last.address)
      lines = data.readlines.map(&:chomp)
      data.close

      expect(lines[0]).to match(/Your ReportExample Here/)
    end
  end
end
