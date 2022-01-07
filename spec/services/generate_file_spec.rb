require 'rails_helper'

describe GenerateFile do
  let(:default_address) { Rails.root.join(Rails.configuration.report_generator[:report_default]) }
  let(:low_address) { Rails.root.join(Rails.configuration.report_generator[:report_low]) }
  let(:default_report) { build(:generate_file, :default) }
  let(:low_report) { build(:generate_file, :low) }
  let(:manage_default_report) { build(:manage_report, :default) }
  let(:manage_low_report) { build(:generate_file, :low) }

  context 'public class methods' do
    it { expect(GenerateFile).to respond_to(:new) }

    context '.new CreateFolder' do
      it '.new CreateFolder low' do
        allow(CreateFolder).to receive(:setting_report_folder).and_return(low_address)

        expect(CreateFolder).to receive(:setting_report_folder).with(low_report.category)

        GenerateFile.new(name: low_report.name, category: low_report.category)
      end

      it '.new CreateFolder default' do
        VCR.use_cassette('report_example') do
          allow(CreateFolder).to receive(:setting_report_folder).and_return(default_address)

          expect(CreateFolder).to receive(:setting_report_folder).with(default_report.category)

          GenerateFile.new(name: default_report.name, category: default_report.category)
        end
      end
    end
  end

  context 'public instance methods' do
    it { expect(GenerateFile.new).to respond_to(:create_file) }

    context '#create_file ManageReport' do
      it '#create_file ManageReport low' do
        allow(ManageReport).to receive(:new).and_return(manage_default_report)
        params = { full_address: anything, category: low_report.category,
                   code: anything, name: low_report.name }

        expect(ManageReport).to receive(:new).with(**params)
        expect(ManageReport.new).to receive(:create)

        GenerateFile.new(name: low_report.name, category: low_report.category).create_file
      end

      it '#create_file ManageReport default' do
        VCR.use_cassette('report_example') do
          ActiveJob::Base.queue_adapter = :test
          allow(ManageReport).to receive(:new).and_return(manage_default_report)
          params = { full_address: anything, category: default_report.category,
                     code: anything, name: default_report.name }

          expect(ManageReport).to receive(:new).with(**params)
          expect(ManageReport.new).to receive(:create)

          GenerateFile.new(name: default_report.name, category: default_report.category).create_file
        end
      end
    end
  end
end