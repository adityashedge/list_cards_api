Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
    post 'users/sign_in' => 'sessions#create', :as => :user_session
    delete 'users/sign_out' => 'sessions#destroy', :as => :destroy_user_session

    post 'users/sign_up' => 'registrations#create', :as => :user_registration

    resources :users, only: [:index]

    resources :lists, except: [:new, :edit] do
      member do
        post :assign_member
        delete "/unassign_member/:member_id" => :unassign_member
      end
    end

    resources :cards, except: [:new, :edit]
  end
end
