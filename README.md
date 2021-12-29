# Capacitated Clustering with impropved k-means
The link of the original paper: https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.414.2123&rep=rep1&type=pdf


The function takes 4 inputs:

1. Input: This should contain the dataframe with the details of the customers with their respective Latitude, Longitude and Demands.

2. Capacity constraint: This is the upper limit of capacity for each cluster.

3. relax_c: This is the relaxation constant. Ideally this should be between 0.7-1. This factor will be multiplied by the capacity constraint so that the number of clusters will be more than the optimal number of clusters, hence we will have some flexibility. Default value is 0.8.

4. iterations: This is the number of iterations to achieve a proper set of centroids for the clusters.

More details: https://shibaprasadbhattacharya.wordpress.com/2021/12/29/capacitated-clustering-with-improved-k-means-in-r/
