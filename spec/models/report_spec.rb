require 'rails_helper'

describe Report do
  it 'has a valid factory' do
    expect(build(:report, :default)).to be_valid
    expect(build(:report, :low)).to be_valid
    expect(build(:report)).to be_valid
  end
  context 'ActiveModel validations' do
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:report_code) }
    it { should validate_presence_of(:report_type) }
    it { should validate_uniqueness_of(:report_code) }
  end
  context 'public class methods' do
    it { expect(Report).to respond_to(:generator) }
    it { expect(Report).to respond_to(:generate_code) }

    it '.generator' do
      ActiveJob::Base.queue_adapter = :test
      expect{ Report.generator }.to have_enqueued_job.on_queue('default')
      expect { Report.generator }.to change(ReportLowPriorityWorker.jobs, :size).by(1)
    end

    it '.generate_code once' do
      attrs = attributes_for(:report, :default)
      code1 = attrs[:report_code]
      allow(SecureRandom).to receive(:base58).with(8).and_return(code1)
      expect(Report.generate_code).to eq(code1)
    end

    it '.generate_code twice' do
      report = create(:report, :low)
      attrs = attributes_for(:report, :default)
      code = attrs[:report_code]
      allow(SecureRandom).to receive(:base58).with(8).and_return(report.report_code)
      allow(SecureRandom).to receive(:base58).with(8).and_return(code)
      expect(Report.generate_code).to eq(code)
    end
  end
end
     # code2 = SecureRandom.base58(8)
      # allow(Report).to receive(:code_exists) { false }
      #allow(SecureRandom).to receive(:base58).with(8).and_call_original
      # expect(Report).to receive(SecureRandom.base58(8)).twice
      #allow(Report).to receive(:exists?).and_return(false) 
      #expect(Report).to receive(:generate_code).and_return(code1)
