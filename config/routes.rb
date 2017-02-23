Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :restaurants, shallow: true do
    resources :reviews do
      resources :endorsements
    end
  end
  root "restaurants#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'restaurants' => 'restaurants#index'

end
