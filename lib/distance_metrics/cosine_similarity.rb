module DbClustering
  module DistanceMetrics
    class CosineSimilarity
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

        # see here for calculation formula: https://en.wikipedia.org/wiki/Cosine_similarity
        numerator = 0
        vector1_array.count.times do |i|
          numerator += vector1_array[i] * vector2_array[i]
        end



        left_sqrt = sqrt(vector1_array.reduce(0) { |sum, v1i| sum + v1i ** 2 })
        right_sqrt = sqrt(vector2_array.reduce(0) { |sum, v2i| sum + v2i ** 2 })
        denominator = left_sqrt * right_sqrt

        numerator.to_f / denominator
      end
    end
  end
end
