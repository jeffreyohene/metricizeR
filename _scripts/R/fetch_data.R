# not completed. bug with access token will be fixed later

library(httr)
library(jsonlite)

# OAuth 2.0 client id and client secret
client_id <- ""
client_secret <- ""

# OAuth endpoints
google_endpoint <- oauth_endpoint(
  authorize = "https://accounts.google.com/o/oauth2/auth",
  access = "https://accounts.google.com/o/oauth2/token"
)

# generate token
google_app <- oauth_app(
  "google",
  key = client_id,
  secret = client_secret
)

#redirect_uri <- "http://localhost:8080/"

# generate token
google_token <- oauth2.0_token(
  endpoint = google_endpoint,
  app = google_app,
  scope = "https://www.googleapis.com/auth/bigquery.readonly"
)


access_token <- ""
project_id <- ""
query <- "SELECT * FROM `table.name` LIMIT 100;"

# Google BigQuery API endpoint
url <- paste0("https://bigquery.googleapis.com/bigquery/v2/projects/", project_id, "/queries")

# prepare the query request
request_body <- list(
  query = query,
  useLegacySql = F
)

request_json <- toJSON(request_body, auto_unbox = TRUE)

# make the POST request to run the query
response <- httr::POST(
  url,
  httr::add_headers(Authorization = paste("Bearer", access_token)),
  httr::content_type_json(),
  body = request_json
)


if (httr::status_code(response) == 200) {
  result <- httr::content(response)
  print(result)
} else {
  print(paste("Error:", httr::status_code(response)))
  print(httr::content(response))
}
