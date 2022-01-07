require 'rails_helper'

describe AsyncReportGenerator do
  it { expect(AsyncReportGenerator).to respond_to(:create) }
  it '.create' do
    ActiveJob::Base.queue_adapter = :test
    expect { AsyncReportGenerator.create }.to have_enqueued_job.on_queue('critical')
    expect { AsyncReportGenerator.create }.to have_enqueued_job.on_queue('default')
    expect { AsyncReportGenerator.create }.to change(ReportLowPriorityWorker.jobs, :size).by(1)
  end
end
