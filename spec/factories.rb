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
    location "Home"
    status "pending"
    association :user
  end
end
