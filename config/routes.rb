JobBoard2::Application.routes.draw do
  root to: "static_pages#home"
  match "/ajuda", to: "static_pages#help"
  match "/sobre", to: "static_pages#about"
  match "/contato", to: "static_pages#contact"
end
