Rails.application.routes.draw do

  resources :pokers do
    collection do
      post 'single_hand'
      post 'multi_hand'
    end
  end
  root 'pokers#index'
end
