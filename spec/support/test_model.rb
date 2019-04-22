class TestModel
  def initialize(vector = [rand(0..100), rand(0..100), rand(0..100)])
    @vector = vector
  end

  def clustering_vector(vector_params)
    if vector_params[:type] == 'Hash'
      vector_as_hash = {}
      @vector.map.with_index{ |x,i| vector_as_hash[i] = x }
      return vector_as_hash
    end

    return @vector
  end
end
