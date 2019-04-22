module DbClustering
  module DistanceMetrics
    class PearsonCorrelation
      include Math

      def initialize(min_dimensions: 1)
        @min_dimensions = min_dimensions
      end

      def distance(vector1, vector2)
        1.0 - correlation(vector1, vector2)
      end

      def correlation(vector1, vector2)
        vector1_array = vector1.array_for_comparison(vector2)
        vector2_array = vector2.array_for_comparison(vector1)

        if vector1_array.count != vector2_array.count
          raise "Vectors with different sizes cannot be compared"
        end

        if vector1_array.count < @min_dimensions
          return Float::INFINITY
        end

        # see here for calculation formula: http://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient
        v1_mean = vector1_array.reduce(:+) / vector1_array.count.to_f
        v2_mean = vector2_array.reduce(:+) / vector2_array.count.to_f

        numerator = 0
        vector1_array.count.times do |i|
          numerator += (vector1_array[i] - v1_mean) * (vector2_array[i] - v2_mean)
        end

        left_sqrt = sqrt(vector1_array.reduce(0) { |sum, v1i| sum + (v1i - v1_mean) ** 2 })
        right_sqrt = sqrt(vector2_array.reduce(0) { |sum, v2i| sum + (v2i - v2_mean) ** 2 })
        denominator = left_sqrt * right_sqrt

        numerator.to_f / denominator
      end

    end
  end
end