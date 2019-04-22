require 'spec_helper'
require 'simple-random'

describe DbClustering::DatasourceAdapters::InMemory, type: :model do

  # describe "#initialize" do
  #   it "initializes with an array" do
  #     expect(DbClustering::DatasourceAdapters::InMemory.new(array: [])).to be_a(DbClustering::DatasourceAdapters::InMemory)
  #   end
  # end
  #
  # describe "#iterate_all_points" do
  #   before(:each) do
  #     @in_memory = DbClustering::DatasourceAdapters::InMemory.new(array: (1..100).to_a)
  #   end
  #
  #   it "iterates through all points" do
  #     x = 0
  #     @in_memory.iterate_all_points { |p| x += 1 }
  #     expect(x).to eq(100)
  #   end
  # end

  describe "#neighbors" do
    before(:each) do
      @dataset = DatasetHelper.normal_distribution(vector_size: 16, clusters: 8, datapoints: 80)

      @in_memory = DbClustering::DatasourceAdapters::InMemory.new(array: @dataset, vector_params: { type: 'Array' })
      @first_point = DbClustering::Models::Point.new(datasource_point: @dataset.first, vector_params: { type: 'Array' })
    end

    context "average difference" do
      before(:each) do
        @average_difference = DbClustering::DistanceMetrics::AverageDifference.new
      end

      it "finds all neighbors" do
        neighbors = @in_memory.neighbors(point: @first_point, distance_metric: @average_difference, max_distance: 10)
        expect(neighbors.count).to eq(10)
        expect(neighbors.first).to be_a(DbClustering::Models::Point)
      end
    end

    context "cosine similarity" do
      before(:each) do
        @cosine_similarity = DbClustering::DistanceMetrics::CosineSimilarity.new
      end

      it "finds all neighbors" do
        neighbors = @in_memory.neighbors(point: @first_point, distance_metric: @cosine_similarity, max_distance: 0.25)
        expect(neighbors.count).to eq(40)
        expect(neighbors.first).to be_a(DbClustering::Models::Point)
      end
    end

    context "euclidean distance" do
      before(:each) do
        @euclidean_distance = DbClustering::DistanceMetrics::EuclideanDistance.new
      end

      it "finds all neighbors" do
        neighbors = @in_memory.neighbors(point: @first_point, distance_metric: @euclidean_distance, max_distance: 50)
        expect(neighbors.count).to eq(10)
        expect(neighbors.first).to be_a(DbClustering::Models::Point)
      end
    end

    context "pearson correlation" do
      before(:each) do
        @pearson_correlation = DbClustering::DistanceMetrics::PearsonCorrelation.new
      end

      it "finds all neighbors" do
        neighbors = @in_memory.neighbors(point: @first_point, distance_metric: @pearson_correlation, max_distance: 0.705)
        expect(neighbors.count).to eq(10)
        expect(neighbors.first).to be_a(DbClustering::Models::Point)
      end
    end

  end

end
