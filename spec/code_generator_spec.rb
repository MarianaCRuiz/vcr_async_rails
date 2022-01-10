require 'rails_helper'

describe CodeGenerator do
  context 'public class methods' do
    it '.create once' do
      code = attributes_for(:report, :default)[:report_code]
      allow(SecureRandom).to receive(:base58).with(8).and_return(code)

      expect(CodeGenerator.create).to eq(code)
    end

    it '.create twice' do
      report = create(:report, :low)
      code = attributes_for(:report, :default)[:report_code]
      allow(SecureRandom).to receive(:base58).with(8).and_return(report.report_code, code)

      expect(CodeGenerator.create).to eq(code)
    end

    it '.create break' do
      allow(Report).to receive(:exists?).and_return(true, false, true)

      CodeGenerator.create

      expect(Report).to have_received(:exists?).exactly(2).times
    end

    it '.create break another approach' do
      expect(Report).to receive(:exists?).exactly(2).times

      allow(Report).to receive(:exists?).and_return(true, false, true)

      CodeGenerator.create
    end
  end
end
