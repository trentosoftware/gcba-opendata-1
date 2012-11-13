Parcelas::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => "application#index"

  #match 'parcelas-por-seccion/:seccion' => 'application#parcelas_by_seccion', :as => 'secciones_json'
  match 'parcelas_by_tag/limit/:limit' => 'application#parcelas_by_tag', :as => 'parcelas_by_tag'
  match 'nearest_parcelas/limit/:limit' => 'application#nearest_parcelas', :as => 'pcercanas_json'
  match 'autocomplete_category/:text' => 'application#autocomplete_category', :as => 'autocomplete_json'

  #resources :application do
  #  member do
  #    get 'index'
  #  end
  #end
end
