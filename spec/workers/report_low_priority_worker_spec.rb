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

  it 'call GenerateFile' do
    attributes = attributes_for(:generate_file, :low)
    allow(GenerateFile).to receive(:new).and_return(GenerateFile.new(**attributes))

    expect(GenerateFile).to receive(:new).with(**attributes)
    expect(GenerateFile.new).to receive(:create_file)

    Sidekiq::Testing.inline!
    ReportLowPriorityWorker.perform_async
  end
end
