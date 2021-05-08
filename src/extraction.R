library(rtweet)
library(tidyverse)
source('credenciales/credenciales.R', encoding = 'UTF-8')
### Functions

extract_tweets <- function(hashtags){
  
  token_tw = create_token(app = APP_NAME,
                          consumer_key = TWITTER_API_KEY,
                          consumer_secret = TWITTER_API_SECRET_KEY,
                          access_token = TWITTER_ACCES_TOKEN,
                          access_secret = TWITTER_ACCES_TOKER_SECRET,
                          set_renv = F
  )
  
  # Validar el correcto funcionamiento de la georeferenciación y el API de google
  # ColCoord <- lookup_coords(address = "Colombia",
  #                           components = "country:Colombia",
  #                           apikey= Sys.getenv(GOOGLE_API_KEY))
  
  df = rtweet::search_tweets2(paste('#',hashtags,sep = ""),n = 18000,include_rts = F, 
                                    token = token_tw,retryonratelimit = T, )
  
  df = df %>% distinct(status_id,.keep_all = T)
  
  ### agregar escritura de la base de datos en S3
  
  df
}

hashtags = c("CalienCensura","SOSColombiaNoDuerme")

base = extract_tweets(hashtags)

write_rds(base,paste0("dataframes/",Sys.Date(),"-base.rds"))

