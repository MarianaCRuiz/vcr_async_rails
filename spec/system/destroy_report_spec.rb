require 'rails_helper'

describe 'Destroying Reports', js: true do
  it 'Reports #delete' do
    VCR.use_cassette('report_example') do
      Sidekiq::Testing.inline!
      ReportExampleJob.perform_now
      ReportLowPriorityWorker.perform_async
      count = Report.count

      visit root_path
      click_on 'Relatórios'
      within 'div#list_reports:nth-child(1)' do
        accept_alert do
          click_on 'Deletar Relatório'
        end
      end

      expect(current_path).to eq(reports_path)
      expect(Report.count).to eq(count - 1)
      expect(page).to have_content('Relatório excluído com sucesso')
      expect(page).to_not have_content('reportexample')
      expect(page).to have_content('lowpriorityreport')
    end
  end
end
