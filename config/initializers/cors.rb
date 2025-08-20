Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://candidates-api-restless-fire-9611.fly.dev"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
