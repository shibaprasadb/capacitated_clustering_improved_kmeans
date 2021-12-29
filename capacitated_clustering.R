capacitated_clustering <- function(input,capacity_constraint,relax_c=0.8,iterations=25){
  require(geodist)
  require(tidyverse)
  
  input %>%
    as.data.frame() %>%
    arrange(desc(demand)) %>%
    rowid_to_column(var = 'id')-> picked_shipments
  
  number_of_picked_cluster <- ceiling(sum(picked_shipments$demand)/(capacity_constraint*relax_c))
  
  picked_shipments %>%
    slice(1:number_of_picked_cluster) %>%
    select(lat,long) %>%
    rowid_to_column(var = 'cluster')-> centroids
  
  n_iteration <- 1
  
  while (n_iteration <= iterations) {
    cluster_capacity <- capacity_constraint- as.vector(picked_shipments[1:number_of_picked_cluster,'demand'])
    
    cluster_list <- rep(NA, nrow(picked_shipments))
    
    cluster_list[1:nrow(centroids)] <- 1:nrow(centroids)
    
    picked_shipments %>%
      slice(c(number_of_picked_cluster+1:n()))-> picked
    
    i <- nrow(centroids)
    
    while (i <= (nrow(picked_shipments)-1)) {
      j <- 2
      
      selected_point <- slice_sample(picked)
      
      selected_point_id <- selected_point$id
      
      picked %>%
        filter(id!=selected_point_id)-> picked
      
      selected_point_demand <- selected_point$demand
      
      selected_point_location <- selected_point[,c('lat','long')]
      
      dist_from_clusters <- geodist(x=as.matrix(selected_point_location), y=as.matrix(centroids))/1000
      
      priority <- dist_from_clusters/selected_point_demand
      
      nearest_cluster <- which.min(priority)
      
      nearest_cluster_capacity <- cluster_capacity[nearest_cluster]
      
      if(selected_point_demand<nearest_cluster_capacity){
        cluster_list[selected_point_id] <- nearest_cluster
        
        picked_shipments$cluster <- cluster_list
        
        cluster_capacity[nearest_cluster] <- nearest_cluster_capacity-selected_point_demand
        
      }else{
        while (is.na(cluster_list[selected_point_id])) {
          
          nearest_cluster <- order(unlist(priority))[j]
          nearest_cluster_capacity <- cluster_capacity[nearest_cluster]
          
          if(selected_point_demand<nearest_cluster_capacity){
            cluster_list[selected_point_id] <- nearest_cluster
            
            picked_shipments$cluster <- cluster_list
            
            cluster_capacity[nearest_cluster] <- nearest_cluster_capacity-selected_point_demand
          }else{
            j<- j+1
          }
          
          
        }
      }
      
      
      i <- i+1
    }
    
    
    picked_shipments %>%
      group_by(cluster) %>%
      summarise(lat=mean(lat),
                long=mean(long))-> centroids
    
    n_iteration <- n_iteration+1
  }
  
  return(picked_shipments)
}
