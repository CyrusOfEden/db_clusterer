module DbClustering
  module DistanceMetrics
    class EuclideanDistance
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

        # see here for calculation formula: http://en.wikipedia.org/wiki/Euclidean_distance
        sum = 0
        vector1_array.count.times do |i|
          sum += (vector1_array[i] - vector2_array[i]) ** 2
        end
        sqrt sum
      end

    end
  end
end