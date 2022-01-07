require 'rails_helper'

describe ReportCriticalJob do
  before(:each) { ActiveJob::Base.queue_adapter = :test }

  it 'verify if queued' do
    VCR.use_cassette('critical_report_example') do
      expect { ReportCriticalJob.perform_later }.to have_enqueued_job.on_queue('critical')
    end
  end

  it 'queue amount' do
    VCR.use_cassette('critical_report_example') do
      ReportCriticalJob.perform_later

      expect(ReportCriticalJob).to have_been_enqueued.exactly(:once)
    end
  end

  it 'queue performed job' do
    VCR.use_cassette('critical_report_example') do
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      expect { ReportCriticalJob.perform_later }.to have_performed_job.on_queue('critical')
    end
  end
  it 'call GenerateFile' do
    VCR.use_cassette('critical_report_example') do
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      attributes = attributes_for(:generate_file, :critical)
      allow(GenerateFile).to receive(:new).and_return(GenerateFile.new(**attributes))

      expect(GenerateFile).to receive(:new).with(**attributes)
      expect(GenerateFile.new).to receive(:create_file)

      ReportCriticalJob.perform_later
    end
  end
end
