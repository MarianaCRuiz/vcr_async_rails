require 'rails_helper'

describe FillCriticalReport do
  let(:critical_address) { Rails.root.join(Rails.configuration.report_generator[:report_critical]) }
  let(:attributes_critical) { attributes_for(:manage_report_content, :critical) }

  context 'public class methods' do
    it { expect(FillCriticalReport).to respond_to(:writing_file) }
    it { expect(FillCriticalReport).to respond_to(:data_source) }

    context '.writing_file' do
      it '.writing_file critical' do
        VCR.use_cassette('critical_report_example') do
          params = attributes_critical[:full_address]
          allow(File).to receive(:new)
            .with(params, 'w')
            .and_return(File.new(params, 'w'))

          expect(File).to receive(:new).with(params, 'w')
          expect(File.new(params, 'w')).to receive(:close)

          FillCriticalReport.writing_file(attributes_critical[:full_address], attributes_critical[:code])
        end
      end

      it '.writing_file critical generate file' do
        VCR.use_cassette('critical_report_example') do
          before_generator = Dir["#{critical_address}/*"].length

          FillCriticalReport.writing_file(attributes_critical[:full_address], attributes_critical[:code])

          expect(Dir["#{critical_address}/*"].length).to eq(before_generator + 1)
        end
      end

      it '.writing_file critical content' do
        VCR.use_cassette('critical_report_example') do
          FillCriticalReport.writing_file(attributes_critical[:full_address], attributes_critical[:code])

          data = File.open(attributes_critical[:full_address])
          lines = data.readlines.map(&:chomp)
          data.close

          expect(lines[0]).to match(/Your CriticalReportExample Here/)
        end
      end
    end

    context '.data_source' do
      it '.data_source class' do
        VCR.use_cassette('critical_report_example') do
          response = FillCriticalReport.data_source

          expect(response.class).to eq(TrueClass)
        end
      end
      it '.data_source Farady' do
        example = File.read(Rails.root.join('spec/fixtures/report_example.json'))
        allow(Faraday).to receive(:get)
          .with('https://jsonplaceholder.typicode.com/posts/1')
          .and_return(instance_double(Faraday::Response, status: 200, body: example))

        FillCriticalReport.data_source

        expect(Faraday).to have_received(:get).with('https://jsonplaceholder.typicode.com/posts/1')
      end
    end
  end
end
