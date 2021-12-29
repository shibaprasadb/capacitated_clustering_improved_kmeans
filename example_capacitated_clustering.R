library(data.table)
set.seed(4)
#Creating a data frame
customer_details <- data.frame(lat=runif(50,77,78),
                               long=runif(50,23,24),
                               demand=runif(50,50,100))
#Calling the function
cap <- capacitated_clustering(picked_region, 500, 0.8, 15)

#Changing the format to convert it into data.table
cap_dt<- data.table(cap)
hulls = cap_dt[,.SD[chull(long,lat)],by=.(cluster)]

#Visualising
ggplot() +
  geom_point(data=cap_dt,aes(x=long,y=lat,color=as.factor(cluster))) +
  geom_polygon(data = hulls,aes(x=long, y=lat, fill=as.factor(cluster),alpha = 0.5))+
  theme_bw()+
  coord_equal()+
  theme_bw()+
  theme(legend.position = 'none')
