module DbClustering
  module DatasourceAdapters
    class ActiveRecord

      def initialize(relation:, vector_params: nil)
        @relation = relation
        @vector_params = vector_params
      end

      def iterate_all_points
        points_count = @relation.count
        current_index = 0

        @relation.find_each do |datasource_point|
          point = DbClustering::Models::Point.new(datasource_point: datasource_point, vector_params: @vector_params)
          yield(point, current_index, points_count)
          current_index += 1
        end
      end

      def neighbors(point:, distance_metric:, max_distance:)
        neighbors = []

        @relation.find_each do |neighbor_candidate|
          candidate_point = DbClustering::Models::Point.new(datasource_point: neighbor_candidate, vector_params: @vector_params)

          if distance_metric.distance(point.vector, candidate_point.vector) <= max_distance
            neighbors << candidate_point
          end
        end

        neighbors
      end

    end
  end
end
