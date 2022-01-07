require 'rails_helper'

describe ManageReport do
  let(:attributes_critical) { attributes_for(:manage_report, :critical) }
  let(:attributes_default) { attributes_for(:manage_report, :default) }
  let(:attributes_low) { attributes_for(:manage_report, :low) }

  context 'public class methods' do
    it { expect(ManageReport).to respond_to(:new) }

    it '.new' do
      expect(ManageReport).to receive(:new).with(**attributes_default)

      ManageReport.new(**attributes_default)
    end
  end

  context 'public instance methods' do
    it { expect(ManageReport.new).to respond_to(:create) }

    it '#create critical' do
      params = { address: attributes_critical[:full_address], report_type: 2, report_code: attributes_critical[:code] }

      expect(FillCriticalReport).to receive(:writing_file)
        .with(attributes_critical[:full_address], attributes_critical[:code])

      expect(Report).to receive(:create!).with(**params)

      ManageReport.new(**attributes_critical).create
    end

    it '#create default' do
      params = { address: attributes_default[:full_address], report_type: 1, report_code: attributes_default[:code] }

      expect(FillDefaultReport).to receive(:writing_file)
        .with(attributes_default[:full_address], attributes_default[:code])

      expect(Report).to receive(:create!).with(**params)

      ManageReport.new(**attributes_default).create
    end

    it '#create low' do
      params = { address: attributes_low[:full_address], report_type: 0, report_code: attributes_low[:code] }

      expect(FillLowReport).to receive(:writing_file).with(attributes_low[:full_address], attributes_low[:code])
      expect(Report).to receive(:create!).with(**params)

      ManageReport.new(**attributes_low).create
    end
    xit '.destroy_all_files'
    xit '.destroy_file'
  end

  context 'private instance methods' do
    it { expect(ManageReport.new(**attributes_critical).send(:klass)).to eq(FillCriticalReport) }
    it { expect(ManageReport.new(**attributes_default).send(:klass)).to eq(FillDefaultReport) }
    it { expect(ManageReport.new(**attributes_low).send(:klass)).to eq(FillLowReport) }

    it { expect(ManageReport.new(**attributes_critical).send(:report_type)).to eq(2) }
    it { expect(ManageReport.new(**attributes_default).send(:report_type)).to eq(1) }
    it { expect(ManageReport.new(**attributes_low).send(:report_type)).to eq(0) }
  end
end
