require 'rails_helper'

describe 'Accessing Reports' do
  before(:each) do
    VCR.insert_cassette('critical_report_example')
    VCR.insert_cassette('report_example')
    Sidekiq::Testing.inline!
    ReportCriticalJob.perform_now
    ReportExampleJob.perform_now
    ReportLowPriorityWorker.perform_async
  end
  after(:each) do
    VCR.eject_cassette
    VCR.eject_cassette
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
