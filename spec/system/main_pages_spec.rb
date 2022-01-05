require 'rails_helper'

describe 'Accessing Pages' do
  it 'root' do
    visit root_path

    expect(current_path).to eq(root_path)
    expect(page).to have_link('Relatórios')
    expect(page).to have_link('Home')
    expect(page).to have_link('Sidekiq')
  end

  it 'reports' do
    visit root_path
    click_on 'Relatórios'

    expect(current_path).to eq(reports_path)
    expect(page).to have_link('Relatórios')
    expect(page).to have_link('Home')
    expect(page).to have_link('Sidekiq')
  end

  it 'return root' do
    visit root_path
    click_on 'Relatórios'
    click_on 'Home'

    expect(current_path).to eq(root_path)
    expect(page).to have_link('Relatórios')
    expect(page).to have_link('Home')
    expect(page).to have_link('Sidekiq')
  end

  it 'sidekiq' do
    visit root_path
    click_on 'Sidekiq'

    expect(current_path).to eq(sidekiq_web_path)
  end
end
