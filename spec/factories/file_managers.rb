FactoryBot.define do
  factory :file_manager do # :full_address, :category, :code, :name
    category { :report_default }
    name { Rails.configuration.report_generator[:default_name] }

    trait :default do
      category { :report_default }
    end
    trait :low do
      category { :report_low }
      name { Rails.configuration.report_generator[:low_name] }
    end
    trait :critical do
      category { :report_critical }
      name { Rails.configuration.report_generator[:critical_name] }
    end
  end
end
