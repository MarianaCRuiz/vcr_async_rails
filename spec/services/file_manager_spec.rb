require 'rails_helper'

describe FileManager do
  include ActiveJob::TestHelper
  let(:path_reports) { Rails.configuration.report_generator[:reports_folder] }
  let(:path_critical) { Rails.configuration.report_generator[:report_critical] }
  let(:path_default) { Rails.configuration.report_generator[:report_default] }
  let(:path_low) { Rails.configuration.report_generator[:report_low] }

  let(:critical_report) { build(:file_manager, :critical) }
  let(:default_report) { build(:file_manager, :default) }
  let(:low_report) { build(:file_manager, :low) }

  let(:manage_critical_report) { build(:report_content_manager, :critical) }
  let(:manage_default_report) { build(:report_content_manager, :default) }
  let(:manage_low_report) { build(:report_content_manager, :low) }

  context 'public class methods' do
    it { expect(FileManager).to respond_to(:new) }
    it { expect(FileManager).to respond_to(:destroy_all_files) }
    it { expect(FileManager).to respond_to(:destroy_file) }

    context '.new FolderManager' do
      it '.new FolderManager low' do
        allow(FolderManager).to receive(:setting_report_folder).and_return(Rails.root.join(path_low))

        expect(FolderManager).to receive(:setting_report_folder).with(low_report.category)

        FileManager.new(name: low_report.name, category: low_report.category)
      end

      it '.new FolderManager default' do
        VCR.use_cassette('report_example') do
          allow(FolderManager).to receive(:setting_report_folder).and_return(Rails.root.join(path_default))

          expect(FolderManager).to receive(:setting_report_folder).with(default_report.category)

          FileManager.new(name: default_report.name, category: default_report.category)
        end
      end

      it '.new FolderManager critical' do
        VCR.use_cassette('critical_report_example') do
          allow(FolderManager).to receive(:setting_report_folder).and_return(Rails.root.join(path_critical))

          expect(FolderManager).to receive(:setting_report_folder).with(critical_report.category)

          FileManager.new(name: critical_report.name, category: critical_report.category)
        end
      end
    end
    it '.destroy_all_files' do
      VCR.use_cassette('critical_report_example') do
        ReportCriticalJob.perform_now
      end
      VCR.use_cassette('report_example') do
        ReportExampleJob.perform_now
      end
      Sidekiq::Testing.inline!
      ReportLowPriorityWorker.perform_async
      before_destroy = Dir[Rails.root.join("#{path_reports}/**/*.html")].length

      FileManager.destroy_all_files

      expect(Dir[Rails.root.join("#{path_reports}/**/*.html")].length).to eq(before_destroy - 3)
    end

    it '.destroy_file critical' do
      VCR.use_cassette('critical_report_example') do
        ReportCriticalJob.perform_now
      end
      before_destroy = Dir[Rails.root.join("#{path_critical}/*.html")].length

      FileManager.destroy_file(Report.last)

      expect(Dir[Rails.root.join("#{path_critical}/*")].length).to eq(before_destroy - 1)
    end

    it '.destroy_file default' do
      VCR.use_cassette('report_example') do
        ReportExampleJob.perform_now
      end
      before_destroy = Dir[Rails.root.join("#{path_default}/*.html")].length

      FileManager.destroy_file(Report.last)

      expect(Dir[Rails.root.join("#{path_default}/*")].length).to eq(before_destroy - 1)
    end

    it '.destroy_file low' do
      Sidekiq::Testing.inline!
      ReportLowPriorityWorker.perform_async
      before_destroy = Dir[Rails.root.join("#{path_low}/*.html")].length

      FileManager.destroy_file(Report.last)

      expect(Dir[Rails.root.join("#{path_low}/*")].length).to eq(before_destroy - 1)
    end
  end

  context 'public instance methods' do
    it { expect(FileManager.new).to respond_to(:create_file) }

    context '#create_file ReportContentManager' do
      it '#create_file ReportContentManager low' do
        allow(ReportContentManager).to receive(:new).and_return(manage_low_report)
        params = { full_address: anything, category: low_report.category,
                   code: anything, name: low_report.name }

        expect(ReportContentManager).to receive(:new).with(**params)
        expect(ReportContentManager.new).to receive(:create)

        FileManager.new(name: low_report.name, category: low_report.category).create_file
      end

      it '#create_file ReportContentManager default' do
        VCR.use_cassette('report_example') do
          ActiveJob::Base.queue_adapter = :test
          allow(ReportContentManager).to receive(:new).and_return(manage_default_report)
          params = { full_address: anything, category: default_report.category,
                     code: anything, name: default_report.name }

          expect(ReportContentManager).to receive(:new).with(**params)
          expect(ReportContentManager.new).to receive(:create)

          FileManager.new(name: default_report.name, category: default_report.category).create_file
        end
      end

      it '#create_file ReportContentManager critical' do
        VCR.use_cassette('critical_report_example') do
          ActiveJob::Base.queue_adapter = :test
          allow(ReportContentManager).to receive(:new).and_return(manage_critical_report)
          params = { full_address: anything, category: critical_report.category,
                     code: anything, name: critical_report.name }

          expect(ReportContentManager).to receive(:new).with(**params)
          expect(ReportContentManager.new).to receive(:create)

          FileManager.new(name: critical_report.name, category: critical_report.category).create_file
        end
      end
    end
  end
end
