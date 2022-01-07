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
      expect { ReportExampleJob.perform_later }.to have_performed_job.on_queue('default')
    end
  end
  it 'call ArrangeGenerateFile' do
    VCR.use_cassette('report_example') do
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      attributes = attributes_for(:arrange_generate_file, :default)
      allow(ArrangeGenerateFile).to receive(:new).and_return(ArrangeGenerateFile.new(**attributes))

      expect(ArrangeGenerateFile).to receive(:new).with(**attributes).once
      expect(ArrangeGenerateFile.new).to receive(:create_file)

      ReportExampleJob.perform_later
    end
  end
end
