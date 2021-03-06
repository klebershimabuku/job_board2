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

  factory :publisher_with_contact_info, :class => "User" do
    sequence(:name) { |n| "Person #{n}" } 
    sequence(:email) { |n| "person#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    sign_in_count 1
    role "publisher"
    contact_info { Factory(:contact_info) }
  end

  factory :publisher_without_contact_info, :class => "User" do
    sequence(:name) { |n| "Person #{n}" } 
    sequence(:email) { |n| "person#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    sign_in_count 1
    role "publisher"
  end

  factory :published_post, :class => Post do
    title "Some title"
    description "Type some text here"
    location "Shizuoka-ken"
    status "published"
    tags 'shizuoka-ken'
    association :user
  end

  factory :expired_post, :class => Post do
    title "Some title"
    description "Type some text here"
    location "Shizuoka-ken"
    status "expired"
    tags 'shizuoka-ken'
    association :user
  end    

  factory :pending_post, :class => Post do
    title "Some title"
    description "Type some text here"
    location "Shizuoka-ken"
    status "pending"
    tags 'shizuoka-ken'
    association :user
  end

  factory :suspended_post, :class => Post do
    title "Some title"
    description "Type some text here"
    location "Shizuoka-ken"
    status "suspended"
    tags 'shizuoka-ken'
    association :user
  end

  factory :approved_post, :class => Post do
    title "Some title"
    description "Type some text here"
    location "Shizuoka-ken"
    status "approved"
    tags 'shizuoka-ken'
    association :user
  end

  factory :contact_info do 
    title "Company Name"
    description "Address here, phone numbers and email addres"
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
