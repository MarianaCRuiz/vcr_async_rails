class Report < ApplicationRecord
  enum report_type: { low_priority: 0, default_priority: 1 }
end
