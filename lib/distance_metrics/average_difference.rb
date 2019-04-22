module DbClustering
  module DistanceMetrics
    class AverageDifference
      include Math

      def initialize(min_dimensions: 1)
        @min_dimensions = min_dimensions
      end

      def distance(vector1, vector2)
        vector1_array = vector1.array_for_comparison(vector2)
        vector2_array = vector2.array_for_comparison(vector1)

        if vector1_array.count != vector2_array.count
          raise "Vectors with different sizes cannot be compared"
        end

        if vector1_array.count < @min_dimensions
          return Float::INFINITY
        end

        sum = vector1_array.map.with_index{ |x, i| (x - vector2_array[i]).abs }.reduce(&:+)
        sum / vector1_array.count.to_f
      end
    end
  end
end
