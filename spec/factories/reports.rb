FactoryBot.define do
  factory :report do
    report_code { Report.generate_code }
    report_type { 1 }
    path = Rails.configuration.report_generator[:report_default]
    address { Rails.root.join("#{path}/reportexample#{report_code}.html") }

    trait :default do
      report_type { 1 }
      path = Rails.configuration.report_generator[:report_default]
      address { Rails.root.join("#{path}/reportexample#{report_code}.html") }
    end
    trait :low do
      report_type { 0 }
      path = Rails.configuration.report_generator[:report_low]
      address { Rails.root.join("#{path}/lowpriorityreport#{report_code}.html") }
    end
  end
end
