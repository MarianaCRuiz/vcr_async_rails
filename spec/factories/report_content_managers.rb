FactoryBot.define do
  factory :report_content_manager do # :full_address, :category, :code
    name = Rails.configuration.report_generator[:default_name]
    path = Rails.configuration.report_generator[:report_default]

    code { Report.generate_code }
    category { :report_default }
    full_address { Rails.root.join("#{path}/#{name}#{code}.html") }

    trait :default do
      name1 = Rails.configuration.report_generator[:default_name]
      path1 = Rails.configuration.report_generator[:report_default]

      category { :report_default }
      full_address { Rails.root.join("#{path1}/#{name1}#{code}.html") }
    end
    trait :low do
      name2 = Rails.configuration.report_generator[:low_name]
      path2 = Rails.configuration.report_generator[:report_low]

      category { :report_low }
      full_address { Rails.root.join("#{path2}/#{name2}#{code}.html") }
    end
    trait :critical do
      name3 = Rails.configuration.report_generator[:critical_name]
      path3 = Rails.configuration.report_generator[:report_critical]

      category { :report_critical }
      full_address { Rails.root.join("#{path3}/#{name3}#{code}.html") }
    end
  end
end
