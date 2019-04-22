# For more information see https://en.wikipedia.org/wiki/DBSCAN

module DbClustering
  module Algorithms
    class Dbscan

      attr_accessor :datasource, :clusters

      def initialize(datasource:, distance_metric:, debug: false)
        @datasource = datasource
        @distance_metric = distance_metric
        @clusters = []
        @debug = debug
      end

      def cluster(max_distance:, min_neighbors:)
        @clusters = []
        cluster = nil

        if @debug
          last_printed_progress = 0.0
        end

        @datasource.iterate_all_points do |point, current_index, points_count|
          neighbors = @datasource.neighbors(point: point, distance_metric: @distance_metric, max_distance: max_distance)

          if neighbors.count < min_neighbors
            point.is_noise = true
          elsif point.cluster.nil?
            cluster = DbClustering::Models::Cluster.new
            @clusters << cluster
            cluster.add(point)

            expand_cluster(point, neighbors, max_distance)
          end

          yield(point, current_index, points_count) if block_given?

          if @debug
            point_type_string = point.is_edge_point? ? 'E' : point.is_core_point? ? 'C' : 'N'
            print point_type_string

            progress = (current_index + 1) * 100 / points_count.to_f

            if progress > last_printed_progress + 1
              print "[#{progress.to_i}%]"
              last_printed_progress = progress
            end
          end
        end

        if @debug
          print "\n"
          puts "#{clusters.count} clusters found"
        end
      end

      def expand_cluster(point, neighbors, max_distance)
        neighbors.each do |neighbor|
          if neighbor.cluster.nil?
            point.cluster.add(neighbor)

            if @debug
              print "+"
            end

            neighbors_of_neighbor = @datasource.neighbors(point: neighbor, distance_metric: @distance_metric, max_distance: max_distance)
            neighbors_of_neighbor.each do |neighbor_of_neighbor|
              neighbors << neighbor_of_neighbor unless neighbors.include?(neighbor_of_neighbor)
            end
          end
        end
      end

    end
  end
end
