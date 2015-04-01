FactoryGirl.define do
  factory :user do
    role :normal

    factory :administrator, parent: :user do
      role :administrator
    end

    factory :superuser, parent: :user do
      role :superuser
    end
  end

end
