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
  it 'call FileManager' do
    VCR.use_cassette('critical_report_example') do
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      attributes = attributes_for(:file_manager, :critical)
      allow(FileManager).to receive(:new).and_return(FileManager.new(**attributes))

      expect(FileManager).to receive(:new).with(**attributes).once
      expect(FileManager.new).to receive(:create_file)

      ReportCriticalJob.perform_later
    end
  end
end
