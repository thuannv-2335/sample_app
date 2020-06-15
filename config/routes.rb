Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "pages/home"
    get "pages/help"
    get "static_pages/home"
    get "static_pages/help"
  end
end
