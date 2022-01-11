class Report < ApplicationRecord
  enum report_type: { low_priority: 0, default_priority: 1, critical_priority: 2 }
  enum file_condition: { failure: 10, success: 100 }
  validates :address, :report_type, :report_code, :file_condition, presence: true
  validates :report_code, uniqueness: true
end
