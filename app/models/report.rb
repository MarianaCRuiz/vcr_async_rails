class Report < ApplicationRecord
  enum report_type: { low_priority: 0, default_priority: 1, critical_priority: 2 }
  validates :address, :report_type, :report_code, presence: true
  validates :report_code, uniqueness: true

  def self.generate_code
    loop do
      @code = SecureRandom.base58(8)
      break unless Report.exists?(report_code: @code)
    end
    @code
  end
end
