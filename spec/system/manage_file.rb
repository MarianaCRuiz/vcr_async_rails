require 'rails_helper'

describe 'View Reports Generated' do
  include ActiveJob::TestHelper
  before(:each) do
    VCR.insert_cassette('critical_report_example')
    VCR.insert_cassette('report_example')
    Sidekiq::Testing.inline!
  end
  after(:each) do
    VCR.eject_cassette
    VCR.eject_cassette
  end

  it 'Reports #create #index success' do
    perform_enqueued_jobs do
      visit root_path
      click_on 'Relatórios'
      click_on 'Gerar Novo'
      click_on 'Relatórios'

      expect(current_path).to eq(reports_path)
      expect(Report.count).to eq(3)
      expect(page).to have_button('Gerar Novo')
      expect(page).to have_content('criticalpriorityreport')
      expect(page).to have_content('reportexample')
      expect(page).to have_content('lowpriorityreport')
    end
  end

  it 'Reports #create #index failure' do
    perform_enqueued_jobs do
      allow(CriticalReportGenerator).to receive(:writing_file).and_return(false)
      allow(DefaultReportGenerator).to receive(:writing_file).and_return(false)
      allow(LowReportGenerator).to receive(:writing_file).and_return(true)

      visit root_path
      click_on 'Relatórios'
      click_on 'Gerar Novo'
      click_on 'Relatórios'

      expect(current_path).to eq(reports_path)
      expect(Report.count).to eq(1)
      expect(page).to_not have_content('criticalpriorityreport')
      expect(page).to_not have_content('reportexample')
      expect(page).to have_content('lowpriorityreport')
    end
  end
end
