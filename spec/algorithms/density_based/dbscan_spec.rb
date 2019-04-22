require 'spec_helper'
require 'support/test_model'

describe DbClustering::Algorithms::Dbscan do
  describe "initialization" do
    before(:each) do
      @dataset = DatasetHelper.normal_distribution

      @in_memory_datasource = DbClustering::DatasourceAdapters::InMemory.new(array: @dataset, vector_params: { type: 'Array' })
      @average_difference_metric = DbClustering::DistanceMetrics::AverageDifference.new

      @dbscan = DbClustering::Algorithms::Dbscan.new(datasource: @in_memory_datasource, distance_metric: @average_difference_metric)
    end

    it "should initialize successfully" do
      expect(@dbscan).to be_a(DbClustering::Algorithms::Dbscan)
    end
  end

  describe "#cluster" do
    before(:each) do
      @clusters_count = 10
      @dataset = DatasetHelper.normal_distribution(vector_size: 10, clusters: @clusters_count, datapoints: 100)

      @in_memory_datasource = DbClustering::DatasourceAdapters::InMemory.new(array: @dataset, vector_params: { type: 'Array' })
      @average_difference_metric = DbClustering::DistanceMetrics::AverageDifference.new

      @dbscan = DbClustering::Algorithms::Dbscan.new(datasource: @in_memory_datasource, distance_metric: @average_difference_metric)
      @dbscan.cluster(max_distance: 10, min_neighbors: 5)
    end

    it "changes all points to clustered or noise – not both" do
      @dbscan.datasource.iterate_all_points do |point|
        expect(point.is_core_point? || point.is_edge_point? || point.is_noise).to eq(true)
        expect(point.is_core_point? && point.is_edge_point?).to eq(false)
        expect(point.is_core_point? && point.is_noise_point?).to eq(false)
        expect(point.is_edge_point? && point.is_noise_point?).to eq(false)
      end
    end

    it "visits all points" do
      @in_memory_datasource.iterate_all_points do |point|
        expect(point.visited?).to eq(true)
      end
    end

    it "finds all clusters" do
      expect(@dbscan.clusters.count).to eq(@clusters_count)
    end
  end

  describe "#expand_cluster" do
    pending "should expand cluster with one point and missing points in cluster"
    pending "should expand cluster with several points and missing points in cluster"
    pending "should expand cluster with several points and without missing points in cluster"
  end
end
