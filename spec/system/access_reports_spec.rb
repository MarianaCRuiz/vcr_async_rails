require 'rails_helper'

describe 'Accessing Reports' do
  it 'Reports #index' do
    VCR.use_cassette('report_example') do
      Sidekiq::Testing.inline!
      ReportExampleJob.perform_now
      ReportLowPriorityWorker.perform_async

      visit root_path
      click_on 'Relatórios'

      expect(current_path).to eq(reports_path)
      expect(page).to have_button('Gerar Novo')
      expect(page).to have_content('reportexample')
      expect(page).to have_content('lowpriorityreport')
    end
  end

  it 'Reports #create' do
    VCR.use_cassette('report_example') do
      visit root_path
      click_on 'Relatórios'
      click_on 'Gerar Novo'
      expect(page).to have_content('Estamos processando seu relatório \\o/')
    end
  end
end
