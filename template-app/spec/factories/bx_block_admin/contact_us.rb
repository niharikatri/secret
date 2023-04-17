FactoryBot.define do
    factory :contact_us, class: 'BxBlockAdmin::ContactUs' do
     full_name {"demo test"}
     email_address {"demo@example.com"}
     mobile_no {"23444455"}
     message {"hello"}
    end
  end