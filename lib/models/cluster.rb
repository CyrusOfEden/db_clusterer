module DbClustering
  module Models
    class Cluster

      attr_accessor :points, :id

      def initialize
        @points = []
        @id = SecureRandom.urlsafe_base64(3, false)
      end

      def add(point)
        @points << point
        point.cluster = self
      end

    end
  end
end
