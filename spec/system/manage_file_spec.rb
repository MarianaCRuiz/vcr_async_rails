require 'rails_helper'

describe 'View Reports Generated' do
  include ActiveJob::TestHelper
  let(:path_reports) { Rails.configuration.report_generator[:reports_folder] }
  before(:each) do
    VCR.insert_cassette('critical_report_example')
    VCR.insert_cassette('report_example')
    Sidekiq::Testing.inline!
  end
  after(:each) do
    VCR.eject_cassette
    VCR.eject_cassette
  end

  context 'success' do
    it 'Reports #create #index' do
      perform_enqueued_jobs do
        before = Dir[Rails.root.join("#{path}/**/*.html")].length

        visit root_path
        click_on 'Relatórios'
        click_on 'Gerar Novo'
        click_on 'Relatórios'

        expect(current_path).to eq(reports_path)
        expect(Report.count).to eq(3)
        expect(Dir[Rails.root.join("#{path}/**/*.html")].length).to eq(before + 3)
        expect(page).to have_button('Gerar Novo')
        expect(page).to have_content('criticalpriorityreport')
        expect(page).to have_content('reportexample')
        expect(page).to have_content('lowpriorityreport')
      end
    end
  end

  context 'failure' do
    it 'Reports #create #index' do
      perform_enqueued_jobs do
        allow(CriticalReportGenerator).to receive(:writing_file).and_return(false)
        allow(DefaultReportGenerator).to receive(:writing_file).and_return(false)
        allow(LowReportGenerator).to receive(:writing_file).and_return(true)

        visit root_path
        click_on 'Relatórios'
        click_on 'Gerar Novo'
        click_on 'Relatórios'

        expect(current_path).to eq(reports_path)
        expect(Report.count).to eq(3)
        expect(page).to_not have_content('criticalpriorityreport')
        expect(page).to_not have_content('reportexample')
        expect(page).to have_content('lowpriorityreport')
        expect(page).to have_content('FALHA').twice
      end
    end
  end
end
