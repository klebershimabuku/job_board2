FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" } 
    sequence(:email) { |n| "person#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    sign_in_count 1
    role "member"

    factory :admin do
      role "admin"
    end
  end

  factory :post do
    title "Some title"
    description "Type some text here"
    location "Shizuoka-ken"
    status "pending"
    tags 'shizuoka-ken'
    association :user
  end

  factory :contact_info do 
    title "Company Name"
    description "Address here, phone numbers and email addres"
    association :user
  end

  factory :prefecture do 
    name 'Aichi-ken'
  end

  factory :company do 
    name 'First Company'
    address 'Stree A, 1010'
    description 'We are the champions'
  end
end
