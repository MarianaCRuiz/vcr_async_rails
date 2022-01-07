require 'rails_helper'

describe DefaultReportGenerator do
  let(:default_address) { Rails.root.join(Rails.configuration.report_generator[:report_default]) }
  let(:attributes_default) { attributes_for(:report_content_manager, :default) }

  context 'public class methods' do
    it { expect(DefaultReportGenerator).to respond_to(:writing_file) }
    it { expect(DefaultReportGenerator).to respond_to(:data_source) }

    context '.writing_file' do
      it '.writing_file default' do
        VCR.use_cassette('report_example') do
          params = attributes_default[:full_address]
          allow(File).to receive(:new).with(params, 'w').and_return(File.new(params, 'w'))

          expect(File).to receive(:new).with(params, 'w')
          expect(File.new(params, 'w')).to receive(:close)

          DefaultReportGenerator.writing_file(attributes_default[:full_address], attributes_default[:code])
        end
      end

      it '.writing_file default generate file' do
        VCR.use_cassette('report_example') do
          before_generator = Dir["#{default_address}/*"].length

          DefaultReportGenerator.writing_file(attributes_default[:full_address], attributes_default[:code])

          expect(Dir["#{default_address}/*"].length).to eq(before_generator + 1)
        end
      end

      it '.writing_file default content' do
        VCR.use_cassette('report_example') do
          DefaultReportGenerator.writing_file(attributes_default[:full_address], attributes_default[:code])

          data = File.open(attributes_default[:full_address])
          lines = data.readlines.map(&:chomp)
          data.close

          expect(lines[0]).to match(/Your ReportExample Here/)
        end
      end
    end

    context '.data_source' do
      it '.data_source class' do
        VCR.use_cassette('report_example') do
          response = DefaultReportGenerator.data_source

          expect(response.class).to eq(TrueClass)
        end
      end
      it '.data_source Farady' do
        example = File.read(Rails.root.join('spec/fixtures/report_example.json'))
        allow(Faraday).to receive(:get)
          .with('https://jsonplaceholder.typicode.com/posts/2')
          .and_return(instance_double(Faraday::Response, status: 200, body: example))

        DefaultReportGenerator.data_source

        expect(Faraday).to have_received(:get).with('https://jsonplaceholder.typicode.com/posts/2')
      end
    end
  end
end
