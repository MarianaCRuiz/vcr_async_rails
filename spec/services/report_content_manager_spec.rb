require 'rails_helper'

describe ReportContentManager do
  let(:attributes_critical) { attributes_for(:report_content_manager, :critical) }
  let(:attributes_default) { attributes_for(:report_content_manager, :default) }
  let(:attributes_low) { attributes_for(:report_content_manager, :low) }

  context 'public class methods' do
    it { expect(ReportContentManager).to respond_to(:new) }

    it '.new' do
      expect(ReportContentManager).to receive(:new).with(**attributes_default)

      ReportContentManager.new(**attributes_default)
    end
  end

  context 'public instance methods' do
    it { expect(ReportContentManager.new).to respond_to(:create) }

    it '#create critical' do
      params = { address: attributes_critical[:full_address], report_type: 2, report_code: attributes_critical[:code] }
      allow(CriticalReportGenerator).to receive(:writing_file).and_return(true)

      expect(CriticalReportGenerator).to receive(:writing_file)
        .with(attributes_critical[:full_address], attributes_critical[:code])

      expect(Report).to receive(:create!).with(**params)

      ReportContentManager.new(**attributes_critical).create
    end

    it '#create default' do
      params = { address: attributes_default[:full_address], report_type: 1, report_code: attributes_default[:code] }
      allow(DefaultReportGenerator).to receive(:writing_file).and_return(true)

      expect(DefaultReportGenerator).to receive(:writing_file)
        .with(attributes_default[:full_address], attributes_default[:code])

      expect(Report).to receive(:create!).with(**params)

      ReportContentManager.new(**attributes_default).create
    end

    it '#create low' do
      params = { address: attributes_low[:full_address], report_type: 0, report_code: attributes_low[:code] }
      allow(LowReportGenerator).to receive(:writing_file).and_return(true)

      expect(LowReportGenerator).to receive(:writing_file).with(attributes_low[:full_address], attributes_low[:code])
      expect(Report).to receive(:create!).with(**params)

      ReportContentManager.new(**attributes_low).create
    end
  end

  context 'private instance methods' do
    it { expect(ReportContentManager.new(**attributes_critical).send(:klass)).to eq(CriticalReportGenerator) }
    it { expect(ReportContentManager.new(**attributes_default).send(:klass)).to eq(DefaultReportGenerator) }
    it { expect(ReportContentManager.new(**attributes_low).send(:klass)).to eq(LowReportGenerator) }

    it { expect(ReportContentManager.new(**attributes_critical).send(:report_type)).to eq(2) }
    it { expect(ReportContentManager.new(**attributes_default).send(:report_type)).to eq(1) }
    it { expect(ReportContentManager.new(**attributes_low).send(:report_type)).to eq(0) }
  end
end
