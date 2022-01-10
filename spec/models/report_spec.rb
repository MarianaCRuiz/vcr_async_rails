require 'rails_helper'

describe Report do
  it 'has a valid factory' do
    expect(build(:report, :critical)).to be_valid
    expect(build(:report, :default)).to be_valid
    expect(build(:report, :low)).to be_valid
    expect(build(:report, :success)).to be_valid
    expect(build(:report, :failure)).to be_valid
    expect(build(:report)).to be_valid
  end

  context 'ActiveModel validations' do
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:report_code) }
    it { should validate_presence_of(:report_type) }
    it { should validate_uniqueness_of(:report_code) }
  end
end
