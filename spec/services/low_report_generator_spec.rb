require 'rails_helper'

describe LowReportGenerator do
  let(:low_address) { Rails.root.join(Rails.configuration.report_generator[:report_low]) }
  let(:attributes_low) { attributes_for(:report_content_manager, :low) }
  let(:params_low) do
    { full_address: attributes_low[:full_address], code: attributes_low[:code] }
  end

  context 'public class methods' do
    it { expect(LowReportGenerator).to respond_to(:writing_file) }

    it '.writing_file low' do
      params = attributes_low[:full_address]
      allow(File).to receive(:new).with(params, 'w').and_return(File.new(params, 'w'))

      expect(File).to receive(:new).with(params, 'w')
      expect(File.new(params, 'w')).to receive(:close)

      params_writing = { full_address: attributes_low[:full_address], code: attributes_low[:code] }
      LowReportGenerator.writing_file(**params_writing)
    end

    it '.writing_file low generate file' do
      before_generator = Dir["#{low_address}/*"].length

      LowReportGenerator.writing_file(**params_low)

      expect(Dir["#{low_address}/*"].length).to eq(before_generator + 1)
    end

    it '.writing_file low content' do
      LowReportGenerator.writing_file(**params_low)
      data = File.open(attributes_low[:full_address])
      lines = data.readlines.map(&:chomp)
      data.close

      expect(lines[0]).to match(/Your Low Priority Report Here/)
    end
  end
end
