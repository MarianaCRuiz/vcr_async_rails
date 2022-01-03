require 'rails_helper'

describe 'Destroying Reports' do
  it 'Reports #delete' do
    VCR.use_cassette('report_example') do
      Sidekiq::Testing.inline!
      ReportExampleJob.perform_now
      ReportLowPriorityWorker.perform_async

      visit root_path
      click_on 'Relatórios'
      within 'div#list_reports:nth-child(1)' do
        #accept_confirm do
          expect { click_on 'Deletar Relatório' }.to change { Report.count }.by(-1)
        #end
      end

      expect(current_path).to eq(reports_path)
      expect(page).to have_content('Relatório excluído com sucesso')
      expect(page).to_not have_content('reportexample')
      expect(page).to have_content('lowpriorityreport')
    end
  end
end
