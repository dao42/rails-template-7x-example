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
    get 'login', to: 'sessions#new', as: :login
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout
    resource :account, only: [:edit, :update]

    # Mount GoodJob dashboard
    mount GoodJob::Engine => 'good_job', :constraints => AdminConstraint.new

    root to: 'dashboard#index'
  end

  # write your routes here

  mount ActionCable.server => '/cable'
end
