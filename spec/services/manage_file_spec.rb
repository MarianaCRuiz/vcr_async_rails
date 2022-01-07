require 'rails_helper'

describe ManageFile do
  let(:critical_address) { Rails.root.join(Rails.configuration.report_generator[:report_critical]) }
  let(:default_address) { Rails.root.join(Rails.configuration.report_generator[:report_default]) }
  let(:low_address) { Rails.root.join(Rails.configuration.report_generator[:report_low]) }
  let(:critical_report) { build(:manage_file, :critical) }
  let(:default_report) { build(:manage_file, :default) }
  let(:low_report) { build(:manage_file, :low) }
  let(:manage_critical_report) { build(:manage_report_content, :critical) }
  let(:manage_default_report) { build(:manage_report_content, :default) }
  let(:manage_low_report) { build(:manage_report_content, :low) }

  context 'public class methods' do
    it { expect(ManageFile).to respond_to(:new) }

    context '.new CreateFolder' do
      it '.new CreateFolder low' do
        allow(CreateFolder).to receive(:setting_report_folder).and_return(low_address)

        expect(CreateFolder).to receive(:setting_report_folder).with(low_report.category)

        ManageFile.new(name: low_report.name, category: low_report.category)
      end

      it '.new CreateFolder default' do
        VCR.use_cassette('report_example') do
          allow(CreateFolder).to receive(:setting_report_folder).and_return(default_address)

          expect(CreateFolder).to receive(:setting_report_folder).with(default_report.category)

          ManageFile.new(name: default_report.name, category: default_report.category)
        end
      end

      it '.new CreateFolder critical' do
        VCR.use_cassette('critical_report_example') do
          allow(CreateFolder).to receive(:setting_report_folder).and_return(critical_address)

          expect(CreateFolder).to receive(:setting_report_folder).with(critical_report.category)

          ManageFile.new(name: critical_report.name, category: critical_report.category)
        end
      end
    end
    xit '.destroy_all_files'
    xit '.destroy_file'
  end

  context 'public instance methods' do
    it { expect(ManageFile.new).to respond_to(:create_file) }

    context '#create_file ManageReportContent' do
      it '#create_file ManageReportContent low' do
        allow(ManageReportContent).to receive(:new).and_return(manage_low_report)
        params = { full_address: anything, category: low_report.category,
                   code: anything, name: low_report.name }

        expect(ManageReportContent).to receive(:new).with(**params)
        expect(ManageReportContent.new).to receive(:create)

        ManageFile.new(name: low_report.name, category: low_report.category).create_file
      end

      it '#create_file ManageReportContent default' do
        VCR.use_cassette('report_example') do
          ActiveJob::Base.queue_adapter = :test
          allow(ManageReportContent).to receive(:new).and_return(manage_default_report)
          params = { full_address: anything, category: default_report.category,
                     code: anything, name: default_report.name }

          expect(ManageReportContent).to receive(:new).with(**params)
          expect(ManageReportContent.new).to receive(:create)

          ManageFile.new(name: default_report.name, category: default_report.category).create_file
        end
      end

      it '#create_file ManageReportContent critical' do
        VCR.use_cassette('critical_report_example') do
          ActiveJob::Base.queue_adapter = :test
          allow(ManageReportContent).to receive(:new).and_return(manage_critical_report)
          params = { full_address: anything, category: critical_report.category,
                     code: anything, name: critical_report.name }

          expect(ManageReportContent).to receive(:new).with(**params)
          expect(ManageReportContent.new).to receive(:create)

          ManageFile.new(name: critical_report.name, category: critical_report.category).create_file
        end
      end
    end
  end
end
