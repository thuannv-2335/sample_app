Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get  "/help", to: "static_pages#help"
    get "/signup", to: "users#new"

    resources :users, only: %i(create show)
  end
end
