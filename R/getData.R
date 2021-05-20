library(dplyr)
library(lubridate)
library(jsonlite)
library(rtweet)
library(janitor)
library(logger)

log_threshold(INFO)

#### Initial setup ####

secrets <-
  Sys.getenv(c(
    "TWITTER_KEY",
    "TWITTER_SECRET",
    "ACCESS_TOKEN",
    "ACCESS_SECRET"
  ))

current_tweet_data <- read_twitter_csv("data/rstats_tweets.csv")

token <- create_token(
  app = "rtweet-exploration",
  consumer_key = secrets["TWITTER_KEY"],
  consumer_secret = secrets["TWITTER_SECRET"],
  access_token = secrets["ACCESS_TOKEN"],
  access_secret = secrets["ACCESS_SECRET"]
)

#### Updating Rbloggers JSON data ####

log_info("Updating Rbloggers dataset with more recent posts")

rbloggers_latest <-
  get_timeline("Rbloggers", n = 1000, retryonratelimit = TRUE) %>% 
  filter(created_at >= today()-30) %>% 
  remove_empty(which="cols")

rbloggers_json <- toJSON(rbloggers_latest, pretty = TRUE)

write(rbloggers_json, "data/rbloggers.json")
