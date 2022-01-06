require 'rails_helper'

describe CreateFolder do
  let(:general_address) { Rails.root.join(Rails.configuration.report_generator[:reports_folder]) }
  let(:default_address) { Rails.root.join(Rails.configuration.report_generator[:report_default]) }
  let(:low_address) { Rails.root.join(Rails.configuration.report_generator[:report_low]) }

  context 'public class methods' do
    it { expect(CreateFolder).to respond_to(:setting_report_folder) }
    it { expect(CreateFolder).to respond_to(:creating_folder) }

    context '.setting_report_folder' do
      it '.setting_report_folder default' do
        expect(CreateFolder).to receive(:creating_folder).with(:reports_folder)
        expect(CreateFolder).to receive(:creating_folder).with(:report_default)

        CreateFolder.setting_report_folder(:report_default)
      end

      it '.setting_report_folder low' do
        expect(CreateFolder).to receive(:creating_folder).with(:reports_folder)
        expect(CreateFolder).to receive(:creating_folder).with(:report_low)

        CreateFolder.setting_report_folder(:report_low)
      end
    end

    context '.creating_folder' do
      context 'low priority' do
        xit '.creating_folder low directory? true false' do
          allow(File).to receive(:directory?).and_return(true, false)

          CreateFolder.setting_report_folder(:report_low)

          expect(Dir).to have_received(:mkdir).with(general_address)
          expect(Dir).to have_received(:mkdir).with(low_address)
        end

        it '.creating_folder low directory? true false' do
          allow(File).to receive(:directory?).and_return(true, false)

          expect(Dir).to_not receive(:mkdir).with(general_address)
          expect(Dir).to receive(:mkdir).with(low_address)

          CreateFolder.setting_report_folder(:report_low)
        end

        it '.creating_folder low directory? true all true' do
          allow(File).to receive(:directory?).and_return(true, true)

          expect(Dir).to_not receive(:mkdir).with(general_address)
          expect(Dir).to_not receive(:mkdir).with(low_address)

          CreateFolder.setting_report_folder(:report_low)
        end

        it '.creating_folder low directory? false false' do
          allow(File).to receive(:directory?).and_return(false, false)

          expect(Dir).to receive(:mkdir).with(general_address)
          expect(Dir).to receive(:mkdir).with(low_address)

          CreateFolder.setting_report_folder(:report_low)
        end
      end
      context 'default priority' do
        it '.creating_folder default directory? true false' do
          allow(File).to receive(:directory?).and_return(true, false)

          expect(Dir).to_not receive(:mkdir).with(general_address)
          expect(Dir).to receive(:mkdir).with(default_address)

          CreateFolder.setting_report_folder(:report_default)
        end

        it '.creating_folder low directory? true true' do
          allow(File).to receive(:directory?).and_return(true, true)

          expect(Dir).to_not receive(:mkdir).with(general_address)
          expect(Dir).to_not receive(:mkdir).with(low_address)

          CreateFolder.setting_report_folder(:report_default)
        end

        it '.creating_folder low directory? false false' do
          allow(File).to receive(:directory?).and_return(false, false)

          expect(Dir).to receive(:mkdir).with(general_address)
          expect(Dir).to receive(:mkdir).with(default_address)

          CreateFolder.setting_report_folder(:report_default)
        end
      end
    end
  end
end
