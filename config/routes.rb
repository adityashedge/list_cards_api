Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
    post 'users/sign_in' => 'sessions#create', :as => :user_session

    post 'users/sign_up' => 'registrations#create', :as => :user_registration
  end
end
