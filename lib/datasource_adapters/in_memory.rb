module DbClustering
  module DatasourceAdapters
    class InMemory

      def initialize(array:, vector_params: nil)
        @vector_params = vector_params
        @array = array.map{ |datasource_point| DbClustering::Models::Point.new(datasource_point: datasource_point, vector_params: @vector_params) }
      end

      def iterate_all_points
        points_count = @array.count
        @array.each.with_index do |point, current_index|
          yield(point, current_index, points_count)
        end
      end

      def neighbors(point:, distance_metric:, max_distance:)
        neighbors = []

        @array.each do |neighbor_candidate|
          if distance_metric.distance(point.vector, neighbor_candidate.vector) <= max_distance
            neighbors << neighbor_candidate
          end
        end

        neighbors
      end

    end
  end
end
