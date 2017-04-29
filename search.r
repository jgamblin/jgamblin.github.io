library(leaflet)
library(ipapi)
#devtools::install_github("hrbrmstr/ipapi")
library(tidyverse)
 
# Get Top 25,000 Cisco Domains
if (file.exists(fn)) file.remove(fn)
temp <- tempfile()
download.file("http://s3-us-west-1.amazonaws.com/umbrella-static/top-1m.csv.zip",temp)
unzip(temp, "top-1m.csv")
sites <- read_csv("top-1m.csv", col_names = FALSE, n_max=25000)
unlink(temp)

 
#Build Map:
locations <- mutate(geolocate(sites$X2))
sites <- merge(sites, locations, by.x = 0, by.y = 0)
m <- leaflet(sites) %>% addTiles('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png') 
m %>% addMarkers(clusterOptions = markerClusterOptions(), ~lon, ~lat, popup = paste("DNS:", sites$X2, "<br>",
                           "RANK:", sites$X1, "<br>",
                           "IP:", sites$query, "<br>",
                           "ISNP", sites$isp, "<br>",
                           "ASN:", sites$as))