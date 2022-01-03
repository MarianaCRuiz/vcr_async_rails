require 'rails_helper'

describe 'Destroying Reports', js: true do
  it 'Reports #destroy default' do
    VCR.use_cassette('report_example') do
      Sidekiq::Testing.inline!
      ReportExampleJob.perform_now
      ReportLowPriorityWorker.perform_async
      before_destroy_default = Dir[Rails.root.join('spec/reports/default/*')].length
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
      expect(Dir[Rails.root.join('spec/reports/default/*')].length).to eq(before_destroy_default - 1)
    end
  end
  it 'Reports #destroy low priority' do
    VCR.use_cassette('report_example') do
      Sidekiq::Testing.inline!
      ReportExampleJob.perform_now
      ReportLowPriorityWorker.perform_async
      before_destroy_low = Dir[Rails.root.join('spec/reports/low_priority/*')].length
      count = Report.count

      visit root_path
      click_on 'Relatórios'
      within 'div#list_low_reports:nth-child(1)' do
        accept_alert do
          click_on 'Deletar Relatório'
        end
      end

      expect(current_path).to eq(reports_path)
      expect(Report.count).to eq(count - 1)
      expect(page).to have_content('Relatório excluído com sucesso')
      expect(page).to have_content('reportexample')
      expect(page).to_not have_content('lowpriorityreport')
      expect(Dir[Rails.root.join('spec/reports/low_priority/*')].length).to eq(before_destroy_low - 1)
    end
  end
  it 'Reports #destroy_all' do
    VCR.use_cassette('report_example') do
      Sidekiq::Testing.inline!
      ReportExampleJob.perform_now
      ReportLowPriorityWorker.perform_async
      before_destroy_default = Dir[Rails.root.join('spec/reports/default/*')].length
      before_destroy_low = Dir[Rails.root.join('spec/reports/low_priority/*')].length
      count = Report.count

      visit root_path
      click_on 'Relatórios'
      accept_alert do
        click_on 'Deletar todos os Relatórios'
      end

      expect(current_path).to eq(reports_path)
      expect(Report.count).to eq(count - 2)
      expect(page).to have_content('Relatórios excluídos com sucesso')
      expect(page).to_not have_content('reportexample')
      expect(page).to_not have_content('lowpriorityreport')
      expect(Dir[Rails.root.join('spec/reports/default/*')].length).to eq(before_destroy_default - 1)
      expect(Dir[Rails.root.join('spec/reports/low_priority/*')].length).to eq(before_destroy_low - 1)
    end
  end
end
