require 'rails_helper'

describe 'Destroying Reports', js: true do
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
  let(:path_default) { Rails.configuration.report_generator[:report_default] }
  let(:path_low) { Rails.configuration.report_generator[:report_low] }
  let(:path_critical) { Rails.configuration.report_generator[:report_critical] }

  it 'Reports #destroy critical' do
    before_destroy_critical = Dir[Rails.root.join("#{path_critical}/*")].length
    count = Report.count

    visit root_path
    click_on 'Relatórios'
    within 'div#list_critical_reports:nth-child(1)' do
      accept_alert do
        click_on 'Deletar Relatório'
      end
    end

    expect(current_path).to eq(reports_path)
    expect(Report.count).to eq(count - 1)
    expect(page).to have_content('Relatório excluído com sucesso')
    expect(page).to_not have_content('criticalpriorityreport')
    expect(page).to have_content('reportexample')
    expect(page).to have_content('lowpriorityreport')
    expect(Dir[Rails.root.join("#{path_critical}/*")].length).to eq(before_destroy_critical - 1)
  end

  it 'Reports #destroy default' do
    before_destroy_default = Dir[Rails.root.join("#{path_default}/*")].length
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
    expect(page).to have_content('criticalpriorityreport')
    expect(page).to_not have_content('reportexample')
    expect(page).to have_content('lowpriorityreport')
    expect(Dir[Rails.root.join("#{path_default}/*")].length).to eq(before_destroy_default - 1)
  end

  it 'Reports #destroy low priority' do
    before_destroy_low = Dir[Rails.root.join("#{path_low}/*")].length
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
    expect(page).to have_content('criticalpriorityreport')
    expect(page).to have_content('reportexample')
    expect(page).to_not have_content('lowpriorityreport')
    expect(Dir[Rails.root.join("#{path_low}/*")].length).to eq(before_destroy_low - 1)
  end

  it 'Reports #destroy_all' do
    before_destroy_default = Dir[Rails.root.join("#{path_default}/*")].length
    before_destroy_low = Dir[Rails.root.join("#{path_low}/*")].length
    before_destroy_critical = Dir[Rails.root.join("#{path_critical}/*")].length
    count = Report.count

    visit root_path
    click_on 'Relatórios'
    accept_alert do
      click_on 'Deletar todos os Relatórios'
    end

    expect(current_path).to eq(reports_path)
    expect(Report.count).to eq(count - 3)
    expect(page).to have_content('Relatórios excluídos com sucesso')
    expect(page).to_not have_content('criticalpriorityreport')
    expect(page).to_not have_content('reportexample')
    expect(page).to_not have_content('lowpriorityreport')
    expect(Dir[Rails.root.join("#{path_default}/*")].length).to eq(before_destroy_default - 1)
    expect(Dir[Rails.root.join("#{path_low}/*")].length).to eq(before_destroy_low - 1)
    expect(Dir[Rails.root.join("#{path_critical}/*")].length).to eq(before_destroy_critical - 1)
  end
end
