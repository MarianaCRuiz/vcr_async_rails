require 'rails_helper'

describe FillDefaultReport do
  let(:default_address) { Rails.root.join(Rails.configuration.report_generator[:report_default]) }
  let(:attributes_default) { attributes_for(:manage_report, :default) }

  context 'public class methods' do
    xit '.writing_file default' do
      params = [attributes_default[:full_address], 'w']
      allow(File).to receive(:new).with(params).and_return(File.new(params))

      expect(File).to receive(:new).with(params)
      expect(File.new(params).to receive(:close))

      FillLowReport.writing_file(attributes_default[:full_address], attributes_default[:code])
    end
  end
end
