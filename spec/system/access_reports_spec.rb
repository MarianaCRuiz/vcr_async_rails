require 'rails_helper'

describe 'Accessing Reports' do
  before(:each) do
    VCR.use_cassette('critical_report_example') do
      ReportCriticalJob.perform_now
    end
    VCR.use_cassette('report_example') do
      ReportExampleJob.perform_now
    end
    Sidekiq::Testing.inline!
    ReportLowPriorityWorker.perform_async
  end
  it 'Reports #index' do
    visit root_path
    click_on 'Relatórios'

    expect(current_path).to eq(reports_path)
    expect(page).to have_button('Gerar Novo')
    expect(page).to have_content('criticalpriorityreport')
    expect(page).to have_content('reportexample')
    expect(page).to have_content('lowpriorityreport')
  end

  it 'Reports #create' do
    visit root_path
    click_on 'Relatórios'
    click_on 'Gerar Novo'

    expect(page).to have_content('Estamos processando seu relatório \\o/')
  end
end
