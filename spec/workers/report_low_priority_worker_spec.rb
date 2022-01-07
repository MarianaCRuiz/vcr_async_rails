require 'rails_helper'

describe ReportLowPriorityWorker do
  it 'queue' do
    expect(ReportLowPriorityWorker.get_sidekiq_options['queue']).to eq('low')
  end

  it 'worker fake' do
    Sidekiq::Testing.fake!

    expect { ReportLowPriorityWorker.perform_async }.to change(ReportLowPriorityWorker.jobs, :size).by(1)
    expect(ReportLowPriorityWorker.new).to respond_to(:perform)
  end

  it 'call ManageFile' do
    attributes = attributes_for(:manage_file, :low)
    allow(ManageFile).to receive(:new).and_return(ManageFile.new(**attributes))

    expect(ManageFile).to receive(:new).with(**attributes)
    expect(ManageFile.new).to receive(:create_file)

    Sidekiq::Testing.inline!
    ReportLowPriorityWorker.perform_async
  end
end
