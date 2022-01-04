FactoryBot.define do
  factory :report do
    sequence(:report_code) { |n| "#{(0...8).map { rand(65..90).chr }.join}#{n}" }
    trait :default do
      report_type { 1 }
      address { Rails.root.join('spec/reports/default', "reportexample#{report_code}.html") }
    end
    trait :low do
      report_type { 0 }
      address { Rails.root.join('spec/reports/default', "lowpriorityreport#{report_code}.html") }
    end
  end
end
