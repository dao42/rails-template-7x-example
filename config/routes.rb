class AdminConstraint
  def matches?(request)
    return false unless request.session[:current_admin_id].present?

    admin = Administrator.find_by(id: request.session[:current_admin_id])
    admin.present?
  end
end

Rails.application.routes.draw do
  # Do not write business logic at admin dashboard
  namespace :admin do
    resources :books
    resources :orders, only: [:index, :show, :update, :destroy]
    
    get 'login', to: 'sessions#new', as: :login
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout
    resource :account, only: [:edit, :update]

    # Mount GoodJob dashboard
    mount GoodJob::Engine => 'good_job', :constraints => AdminConstraint.new

    root to: 'dashboard#index'
  end

  # write your routes here
  root 'books#index'
  
  resources :books, only: [:index, :show]
  
  resources :payments, only: [:create] do
    collection do
      get :success
      get :cancel
      post :webhook
    end
  end

  mount ActionCable.server => '/cable'
end
