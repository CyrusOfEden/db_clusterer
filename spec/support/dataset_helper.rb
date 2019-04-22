require 'support/test_model'

class DatasetHelper
  def self.normal_distribution(vector_size: 3, clusters: 8, datapoints: 80)
    dataset = []
    sr = SimpleRandom.new

    (1..datapoints).each do |i|
      mean = -90 + (i % clusters) * (180.0 / clusters)
      standard_deviation = 5

      vector = []
      vector_size.times{ |k| vector << sr.normal(mean, standard_deviation) }
      dataset << TestModel.new(vector)
    end

    dataset
  end
end
