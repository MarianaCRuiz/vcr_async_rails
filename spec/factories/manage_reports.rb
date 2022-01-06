FactoryBot.define do
  factory :manage_report do # :address, :category, :code
    name = Rails.configuration.report_generator[:default_name]
    path = Rails.configuration.report_generator[:report_default]

    code { Report.generate_code }
    category { :report_default }
    address { Rails.root.join("#{path}/#{name}#{code}.html") }

    trait :default do
      category { :report_default }
    end
    trait :low do
      name = Rails.configuration.report_generator[:low_name]
      path = Rails.configuration.report_generator[:report_low]
      category { :report_low }
      address { Rails.root.join("#{path}/#{name}#{code}.html") }
    end
  end
end
