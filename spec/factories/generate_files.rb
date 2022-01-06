FactoryBot.define do
  factory :generate_file do # :full_address, :category, :code, :name
    category { :report_default }
    name { Rails.configuration.report_generator[:default_name] }

    trait :default do
      category { :report_default }
    end
    trait :low do
      category { :report_low }
      name { Rails.configuration.report_generator[:low_name] }
    end
  end
end
