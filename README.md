# DBClustering [![Build Status](https://travis-ci.org/Flinesoft/db_clustering.svg?branch=develop)](https://travis-ci.org/Flinesoft/db_clustering)

Please note that this gem is still in its very early stages and should not considered stable.
Also it currently only supports the in-memory datasource adapter. In future versions an ActiveRecord adapter is planned but this is not yet implemented. Stay tuned.

## Requirements

Ruby 2.1+ is required, earlier Rubies may work but are not officially supported.

## Getting Started

This gem was developed to work best in Ruby on Rails projects.

1. Add this gem to your Gemfile

        gem 'db_clustering'

2. Rund `bundle install` in your terminal

3. Implement the `clustering_vector` method in your model class and return either:
   - an **array** with numeric values for similarity comparison
   - a **hash** with numeric values for similarity comparison between keys existing in both hashes

   The `clustering_vector` can either have no parameters at all or one parameter that we call `vector_params` within this documentation. You can of course name it the way you want – it will just be passed through as you specify in a later step (step 5).

   See `TestModel` class within the `spec/support` directory for a very simple example.

4. Decide for a *distance metric* and initialize it, e.g.:

   ``` ruby
   average_difference = DbClustering::DistanceMetrics::AverageDifference.new

   # Instead you can also use one of the following:
   cosine_similarity = DbClustering::DistanceMetrics::CosineSimilarity.new
   euclidean_distance = DbClustering::DistanceMetrics::EuclideanDistance.new
   pearson_correlation = DbClustering::DistanceMetrics::PearsonCorrelation.new
   ```

   You can also specify that a distance only makes sense if a minimum number of values are given when comparing two vectors. This is especially useful in combination with a hash clustering vector and many different keys. A distance will then only be calculated if the given `min_dimensions` is reached or exceeded – otherwise the distance will be set to (near) infinity and therefore the vectors will not be ranked as in the same cluster:

   ``` ruby
   average_difference = DbClustering::DistanceMetrics::AverageDifference.new(min_dimensions: 5)

   # Instead you can also use one of the following:
   cosine_similarity = DbClustering::DistanceMetrics::CosineSimilarity.new(min_dimensions: 5)
   euclidean_distance = DbClustering::DistanceMetrics::EuclideanDistance.new(min_dimensions: 5)
   pearson_correlation = DbClustering::DistanceMetrics::PearsonCorrelation.new(min_dimensions: 5)
   ```

5. Decide for a datasource adapter (currently only in-memory datasource available), e.g.:

   ``` ruby
   in_memory_datasource = DbClustering::DatasourceAdapters::InMemory.new(array: your_array)
   ```

   If you decided to accept a `vector_params` parameter in step 3 please add a non-nil parameter in your datasource like this:

   ``` ruby
   in_memory_datasource = DbClustering::DatasourceAdapters::InMemory.new(array: your_array, vector_params: { any_object: :to_passthrough })
   ```

   Please note that `your_array` should be an array filled with objects of the class type that implements the `clustering_vector` method from step 3.

   An **ActiveRecord datasource** type is planned but not yet implemented. Please stay tuned.

6. Decide for an **algorithm** and initialize it:

   ``` ruby
   dbscan = DbClustering::Algorithms::Dbscan.new(datasource: in_memory_datasource, distance_metric: average_difference)
   ```
   Please note that currently **only one algorithm is available**. More algorithms aren't currently planned but may be added if needed. Contributions are welcome, of course.

7. Decide for the **algorithm parameters** and start the process of clustering your data:

   ``` ruby
   dbscan.cluster(max_distance: 10, min_neighbors: 5)
   ```
   The `max_distance` is the epsilon parameter and the `min_neighbors` the minPts parameter from the usual DBSCAN algorithm documentation (e.g. Wikipedia). You might want to try different values here first before you decide for the right values for your purpose.

   If you're interested in the progress of the algorithm you can run some code after each iteration of it (for DBSCAN this would mean after clustering a single point with its neighbors). Please note though that the current information at that point may be incomplete so don't use this as a method to receive a portion of the final results, treat it more like a partial result or just use it to indicate progress or do some debugging. For example you could do this:

   ``` ruby
   last_printed_progress = 0.0

   dbscan.cluster(max_distance: 10, min_neighbors: 5) do |point, current_index, points_count|
     progress = (current_index + 1) * 100 / points_count.to_f

     if progress > last_printed_progress + 1
       print "[#{progress.to_i}%]"
       last_printed_progress = progress
     end

     if point.cluster
       print "(#{point.cluster.id}|#{point.cluster.points.count})"
     else
       print "(nil|0)"
     end
   end
   ```

   Plase also take note that the `max_distance` value is **highly dependent on the type of metric** you decided to go for. For the `AverageDifference` and `EuclideanDistance` metrics it can be an **open-ended positive value**. For the `CosineSimilarity` and `PearsonCorrelation` types it needs to be a value between 0 and 2 where a value of `0` means "100% positive correlation/similarity", a value of `1` means "no correlation/similarity at all" and a value of `2` means "100% negative correlation/similarity". You can use any decimal value in between (e.g. 0.25) as a partly positive/negative correlation.

8. Wait for the calculations to finish and use the results the way you want:

   ``` ruby
   clusters = dbscan.clusters # the resulting Clusters, each cluster contains Points
   first_cluster = clusters.first
   point = first_cluster.points.first
   # a point knows its cluster, and its position in there
   point.cluster # will return the same object as `first_cluster`
   point.is_edge_point? # boolean specifying if it's an edge point of its cluster
   point.is_core_point? # boolean specifying if it's a core point of its cluster
   point.is_noise_point? # boolean specifiying if it's a noise point without a cluster

   # a point also contains the source object specifying the `clustering_vector` method
   your_model = point.datasource_point
   ```

   For more please don't hesitate to have a look into the underlying models under the `lib/models` directory as well as the corresponding specs.

 That's it, it **looks more complicated than it actually** is, just try it out! You can find complete usage examples within the `spec/algorithms/density_based/dbscan_spec.rb` file.

## Contributing

Contributions are welcome. Please fork this project, make your changes and file a pull request. Please also make sure to write tests to ensure your changes persist over time.


## License

This gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).
