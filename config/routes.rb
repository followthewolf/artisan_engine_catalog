Rails.application.routes.draw do
  scope :module => :manage do
    resources :goods,           :except => [ :index, :show ] do
      resources :variants,      :only   => [ :create, :edit, :update, :destroy ]
    end
    
    resources :option_types,    :only   => [ :create, :edit, :update, :destroy ] do
      resources :option_values, :except => [ :index, :show ]
    end
  end
  
  namespace :manage do
    resources :goods,        :only => [ :index ]
    resources :option_types, :only => [ :index ]
  end
  
  resources :goods, :only => [ :show ]
end