FactoryBot.define do
  factory :report do
    report_code { Report.generate_code }
    report_type { 1 }
    path = Rails.configuration.report_generator[:report_default]
    name = Rails.configuration.report_generator[:default_name]
    address { Rails.root.join("#{path}/#{name}#{report_code}.html") }

    trait :default do
      report_type { 1 }
    end
    trait :low do
      report_type { 0 }
      path = Rails.configuration.report_generator[:report_low]
      name = Rails.configuration.report_generator[:low_name]
      address { Rails.root.join("#{path}/#{name}#{report_code}.html") }
    end
  end
end
