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
      path1 = Rails.configuration.report_generator[:report_low]
      name1 = Rails.configuration.report_generator[:low_name]
      address { Rails.root.join("#{path1}/#{name1}#{report_code}.html") }
    end
    trait :critical do
      report_type { 2 }
      path2 = Rails.configuration.report_generator[:report_critical]
      name2 = Rails.configuration.report_generator[:critical_name]
      address { Rails.root.join("#{path2}/#{name2}#{report_code}.html") }
    end
  end
end
