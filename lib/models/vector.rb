module DbClustering
  module Models
    class Vector

      attr_reader :hash

      def initialize(object:)
        if object.is_a?(Hash)
          @hash = object
        else
          @array = object
        end
      end

      def array_for_comparison(other_vector)
        if @hash
          if other_vector
            shared_keys = @hash.keys & other_vector.hash.keys
            @hash.select{ |k,v| !k.nil? && shared_keys.include?(k) }.sort.map{ |arr| arr.last }
          else
            @hash.values
          end
        else
          @array
        end
      end
    end
  end
end
