Rails.application.routes.draw do

  get "/", to: "application#root"

  scope "/graphql" do

    # API endpoints
    post "/", to: "graphql#execute"

    # API explorer
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"

  end
end
