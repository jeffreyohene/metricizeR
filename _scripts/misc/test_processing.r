library(dplyr)
library(tidyr)
library(lubridate)

df <- jsonlite::fromJSON("bquxjob_25105fd5_1931c33f443.json")

# clean and transform the event_date to Date format
df$event_date <- as.Date(as.character(df$event_date), format = "%Y%m%d")

# clean the event_timestamp to DateTime format
df$event_timestamp <- as.POSIXct(df$event_timestamp / 1000, origin = "1970-01-01", tz = "UTC")

# handle the event_params column -- will have to do this for all nested fields
# split the event_params into individual columns
df_event_params <- df %>%
  separate(event_params, into = paste0("param_", 1:30), sep = ",", fill = "right")

# remove the original event_params column
df <- df %>%
  select(-event_params)

# merge the new event_params columns back into the original dataframe
df <- cbind(df, df_event_params)

# clean up any columns with all NAs
#df <- df %>% select(where(~ !all(is.na(.))))  # might be useful for validation

# handle any additional columns with timestamps or IDs
df$user_first_touch_timestamp <- as.POSIXct(df$user_first_touch_timestamp / 1000,
                                            origin = "1970-01-01", tz = "UTC")

# filter out rows with missing or incomplete data
#df <- df |> filter(!is.na(event_name) & !is.na(event_timestamp))   # might be useful for validation

head(df)
str(df)
