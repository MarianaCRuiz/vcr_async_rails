require 'rails_helper'

describe ReportContentManager do
  let(:attributes_critical) { attributes_for(:report_content_manager, :critical) }
  let(:attributes_default) { attributes_for(:report_content_manager, :default) }
  let(:attributes_low) { attributes_for(:report_content_manager, :low) }
  let(:params_critical) do
    { address: attributes_critical[:full_address], report_type: 2,
      report_code: attributes_critical[:code] }
  end
  let(:params_default) do
    { address: attributes_default[:full_address], report_type: 1,
      report_code: attributes_default[:code] }
  end
  let(:params_low) do
    { address: attributes_low[:full_address], report_type: 0,
      report_code: attributes_low[:code] }
  end
  let(:success) { 100 }
  let(:failure) { 10 }

  context 'public class methods' do
    it { expect(ReportContentManager).to respond_to(:new) }

    it '.new' do
      expect(ReportContentManager).to receive(:new).with(**attributes_default)

      ReportContentManager.new(**attributes_default)
    end
  end

  context 'public instance methods' do
    it { expect(ReportContentManager.new).to respond_to(:create) }

    context 'success' do
      it '#create critical' do
        params_critical[:file_condition] = success
        allow(CriticalReportGenerator).to receive(:writing_file).and_return(true)

        expect(CriticalReportGenerator).to receive(:writing_file)
          .with(full_address: attributes_critical[:full_address], code: attributes_critical[:code])
        expect(Report).to receive(:create!).with(**params_critical)

        ReportContentManager.new(**attributes_critical).create
      end

      it '#create default' do
        params_default[:file_condition] = success
        allow(DefaultReportGenerator).to receive(:writing_file).and_return(true)

        expect(DefaultReportGenerator).to receive(:writing_file)
          .with(full_address: attributes_default[:full_address], code: attributes_default[:code])

        expect(Report).to receive(:create!).with(**params_default)

        ReportContentManager.new(**attributes_default).create
      end

      it '#create low' do
        params_low[:file_condition] = success
        allow(LowReportGenerator).to receive(:writing_file).and_return(true)

        expect(LowReportGenerator).to receive(:writing_file)
          .with(full_address: attributes_low[:full_address], code: attributes_low[:code])
        expect(Report).to receive(:create!).with(**params_low)

        ReportContentManager.new(**attributes_low).create
      end
    end

    context 'failure' do
      it '#create critical' do
        params_critical[:file_condition] = failure
        allow(CriticalReportGenerator).to receive(:writing_file).and_return(false)

        expect(CriticalReportGenerator).to receive(:writing_file)
          .with(full_address: attributes_critical[:full_address], code: attributes_critical[:code])
        expect(Report).to receive(:create!).with(**params_critical)

        ReportContentManager.new(**attributes_critical).create
      end
      it '#create default' do
        params_default[:file_condition] = failure
        allow(DefaultReportGenerator).to receive(:writing_file).and_return(false)

        expect(DefaultReportGenerator).to receive(:writing_file)
          .with(full_address: attributes_default[:full_address], code: attributes_default[:code])

        expect(Report).to receive(:create!).with(**params_default)

        ReportContentManager.new(**attributes_default).create
      end
      it '#create low' do
        params_low[:file_condition] = failure
        allow(LowReportGenerator).to receive(:writing_file).and_return(false)

        expect(LowReportGenerator).to receive(:writing_file)
          .with(full_address: attributes_low[:full_address], code: attributes_low[:code])
        expect(Report).to receive(:create!).with(**params_low)

        ReportContentManager.new(**attributes_low).create
      end
    end
  end

  context 'private instance methods' do
    it { expect(ReportContentManager.new(**attributes_critical).send(:klass)).to eq(CriticalReportGenerator) }
    it { expect(ReportContentManager.new(**attributes_default).send(:klass)).to eq(DefaultReportGenerator) }
    it { expect(ReportContentManager.new(**attributes_low).send(:klass)).to eq(LowReportGenerator) }

    it { expect(ReportContentManager.new(**attributes_critical).send(:report_type)).to eq(2) }
    it { expect(ReportContentManager.new(**attributes_default).send(:report_type)).to eq(1) }
    it { expect(ReportContentManager.new(**attributes_low).send(:report_type)).to eq(0) }

    it '#get_condition' do
      report_success = ReportContentManager.new(**attributes_low).send(:get_condition, true)
      report_failure = ReportContentManager.new(**attributes_low).send(:get_condition, false)

      expect(report_success).to eq(100)
      expect(report_failure).to eq(10)
    end
  end
end
