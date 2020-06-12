Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "pages/home"
    get "pages/help"
  end
end
