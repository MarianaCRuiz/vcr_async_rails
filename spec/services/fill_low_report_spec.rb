require 'rails_helper'

describe FillLowReport do
  let(:low_address) { Rails.root.join(Rails.configuration.report_generator[:report_low]) }
  let(:attributes_low) { attributes_for(:manage_report_content, :low) }

  context 'public class methods' do
    it { expect(FillLowReport).to respond_to(:writing_file) }

    it '.writing_file low' do
      params = attributes_low[:full_address]
      allow(File).to receive(:new).with(params, 'w').and_return(File.new(params, 'w'))

      expect(File).to receive(:new).with(params, 'w')
      expect(File.new(params, 'w')).to receive(:close)

      FillLowReport.writing_file(attributes_low[:full_address], attributes_low[:code])
    end

    it '.writing_file low generate file' do
      before_generator = Dir["#{low_address}/*"].length

      FillLowReport.writing_file(attributes_low[:full_address], attributes_low[:code])

      expect(Dir["#{low_address}/*"].length).to eq(before_generator + 1)
    end

    it '.writing_file low content' do
      FillLowReport.writing_file(attributes_low[:full_address], attributes_low[:code])
      data = File.open(attributes_low[:full_address])
      lines = data.readlines.map(&:chomp)
      data.close

      expect(lines[0]).to match(/Your Low Priority Report Here/)
    end
  end
end
