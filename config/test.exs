import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fb_cryptocurrency_chatbot, FbCryptocurrencyChatbotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Flr74bt6Dr+9S5Rvlal6vSPdbiVvkvpEeWVBYdEu4g3pyIQTftqFtMqzyVJfmUhV",
  server: false

# In test we don't send emails.
config :fb_cryptocurrency_chatbot, FbCryptocurrencyChatbot.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :fb_cryptocurrency_chatbot, :fb_creds,
  verify_token: "sdfEFRSsaf",
  page_token: ""
