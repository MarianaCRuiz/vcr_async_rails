require 'rails_helper'

describe ManageReportContent do
  let(:attributes_critical) { attributes_for(:manage_report_content, :critical) }
  let(:attributes_default) { attributes_for(:manage_report_content, :default) }
  let(:attributes_low) { attributes_for(:manage_report_content, :low) }

  context 'public class methods' do
    it { expect(ManageReportContent).to respond_to(:new) }

    it '.new' do
      expect(ManageReportContent).to receive(:new).with(**attributes_default)

      ManageReportContent.new(**attributes_default)
    end
  end

  context 'public instance methods' do
    it { expect(ManageReportContent.new).to respond_to(:create) }

    it '#create critical' do
      params = { address: attributes_critical[:full_address], report_type: 2, report_code: attributes_critical[:code] }
      allow(FillCriticalReport).to receive(:writing_file).and_return(true)

      expect(FillCriticalReport).to receive(:writing_file)
        .with(attributes_critical[:full_address], attributes_critical[:code])

      expect(Report).to receive(:create!).with(**params)

      ManageReportContent.new(**attributes_critical).create
    end

    it '#create default' do
      params = { address: attributes_default[:full_address], report_type: 1, report_code: attributes_default[:code] }
      allow(FillDefaultReport).to receive(:writing_file).and_return(true)

      expect(FillDefaultReport).to receive(:writing_file)
        .with(attributes_default[:full_address], attributes_default[:code])

      expect(Report).to receive(:create!).with(**params)

      ManageReportContent.new(**attributes_default).create
    end

    it '#create low' do
      params = { address: attributes_low[:full_address], report_type: 0, report_code: attributes_low[:code] }
      allow(FillLowReport).to receive(:writing_file).and_return(true)

      expect(FillLowReport).to receive(:writing_file).with(attributes_low[:full_address], attributes_low[:code])
      expect(Report).to receive(:create!).with(**params)

      ManageReportContent.new(**attributes_low).create
    end
  end

  context 'private instance methods' do
    it { expect(ManageReportContent.new(**attributes_critical).send(:klass)).to eq(FillCriticalReport) }
    it { expect(ManageReportContent.new(**attributes_default).send(:klass)).to eq(FillDefaultReport) }
    it { expect(ManageReportContent.new(**attributes_low).send(:klass)).to eq(FillLowReport) }

    it { expect(ManageReportContent.new(**attributes_critical).send(:report_type)).to eq(2) }
    it { expect(ManageReportContent.new(**attributes_default).send(:report_type)).to eq(1) }
    it { expect(ManageReportContent.new(**attributes_low).send(:report_type)).to eq(0) }
  end
end
