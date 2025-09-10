Searchkick.client = Elasticsearch::Client.new(
  url: "https://localhost:9200",
  user: "elastic",
  password: "search_1234_search",
  transport_options: {
    ssl: { verify: false }
  }
)
