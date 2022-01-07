require 'rails_helper'

describe Report do
  it 'has a valid factory' do
    expect(build(:report, :critical)).to be_valid
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
      expect { Report.generator }.to have_enqueued_job.on_queue('critical')
      expect { Report.generator }.to have_enqueued_job.on_queue('default')
      expect { Report.generator }.to change(ReportLowPriorityWorker.jobs, :size).by(1)
    end

    it '.generate_code once' do
      code = attributes_for(:report, :default)[:report_code]
      allow(SecureRandom).to receive(:base58).with(8).and_return(code)

      expect(Report.generate_code).to eq(code)
    end

    it '.generate_code twice' do
      report = create(:report, :low)
      code = attributes_for(:report, :default)[:report_code]
      allow(SecureRandom).to receive(:base58).with(8).and_return(report.report_code, code)

      expect(Report.generate_code).to eq(code)
    end

    it '.generate_code break' do
      allow(Report).to receive(:exists?).and_return(true, false, true)

      Report.generate_code

      expect(Report).to have_received(:exists?).exactly(2).times
    end

    it '.generate_code break another approach' do
      expect(Report).to receive(:exists?).exactly(2).times

      allow(Report).to receive(:exists?).and_return(true, false, true)

      Report.generate_code
    end
  end
end
