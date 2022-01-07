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

  it 'call FileManager' do
    attributes = attributes_for(:file_manager, :low)
    allow(FileManager).to receive(:new).and_return(FileManager.new(**attributes))

    expect(FileManager).to receive(:new).with(**attributes)
    expect(FileManager.new).to receive(:create_file)

    Sidekiq::Testing.inline!
    ReportLowPriorityWorker.perform_async
  end
end
