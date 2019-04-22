require 'spec_helper'

describe DbClustering::DistanceMetrics::CosineSimilarity, type: :model do

  before(:each) do
    @cosine_similarity = DbClustering::DistanceMetrics::CosineSimilarity.new
  end

  describe "#distance" do

    context "using array object" do

      it "works with 6 dimensional examples" do
        a1 = [-100, -50, 0, 10, 20, 30]
        a2 = [-100, -50, 0, 20, 30, 40]

        expect_distance(a1, a2, 1.0 - 0.9910606701839321)

        a1[0] = 100
        expect_distance(a1, a2, 1.0 - -0.37591956455252595)

        a1[1] = 50
        expect_distance(a1, a2, 1.0 - -0.7176646232366405)

        a1[3] = 20
        expect_distance(a1, a2, 1.0 - -0.6965185577824071)

        a1[4] = 30
        expect_distance(a1, a2, 1.0 - -0.6646315788560506)

        a1[5] = 40
        expect_distance(a1, a2, 1.0 - -0.6233766233766233)
      end

    end
  end

  describe "#correlation" do

    context "using array object" do
      it "works with 6 dimensional examples" do
        a1 = [-100, -50, 0, 10, 20, 30]
        a2 = [-100, -50, 0, 20, 30, 40]

        expect_correlation(a1, a2, 0.9910606701839321)

        a1[0] = 100
        expect_correlation(a1, a2, -0.37591956455252595)

        a1[1] = 50
        expect_correlation(a1, a2, -0.7176646232366405)

        a1[3] = 20
        expect_correlation(a1, a2, -0.6965185577824071)

        a1[4] = 30
        expect_correlation(a1, a2, -0.6646315788560506)

        a1[5] = 40
        expect_correlation(a1, a2, -0.6233766233766233)
      end

      it "works with 10 dimensional example" do
        a1 = [-100, -75, -50, -25, 0, 10, 30, 50, 70, 90]
        a2 = [-100, -75, -50, -25, 0, 20, 40, 60, 80, 100]

        expect_correlation(a1, a2, 0.9960326819057044)

        a1[0] = 100
        expect_correlation(a1, a2, 0.46833324778347685)

        a1[1] = 75
        expect_correlation(a1, a2, 0.1715023160897239)

        a1[2] = 50
        expect_correlation(a1, a2, 0.039577457559167056)

        a1[3] = 25
        expect_correlation(a1, a2, 0.006596242926527844)

        a1[5] = 20
        expect_correlation(a1, a2, 0.011823033079799202)

        a1[6] = 40
        expect_correlation(a1, a2, 0.02211572157270011)

        a1[7] = 60
        expect_correlation(a1, a2, 0.03716711852501086)

        a1[8] = 80
        expect_correlation(a1, a2, 0.056548774822804536)

        a1[9] = 100
        expect_correlation(a1, a2, 0.07975460122699386)
      end

      it "works with 200 dimensional example" do
        a1 = (-100..0).to_a + (-9..90).to_a
        a2 = (-100..0).to_a + (1..100).to_a

        expect_correlation(a1, a2, 0.994666206187772)

        a1[0] = 100
        expect_correlation(a1, a2, 0.962897882770724)

        a1[1] = 99
        expect_correlation(a1, a2, 0.9317617489896753)

        a1[2] = 98
        expect_correlation(a1, a2, 0.9012514511799424)

        a1[3] = 97
        expect_correlation(a1, a2, 0.871360635676842)

        (4..99).each{ |i| a1[i] = 100 - i }
        expect_correlation(a1, a2, -0.08021501662804613)

        a1[101] = 1
        expect_correlation(a1, a2, -0.0802046101750023)

        a1[102] = 2
        expect_correlation(a1, a2, -0.08017694707226601)

        a1[103] = 3
        expect_correlation(a1, a2, -0.08013202587413609)

        a1[104] = 4
        expect_correlation(a1, a2, -0.08006984697332015)

        (5..100).each{ |i| a1[100+i] = i }
        expect_correlation(a1, a2, 0.0)
      end
    end

    context "using hash object" do
      it "works with 6 dimensional examples" do
        a1 = {a: -100, b: -50, c: 0, d: 100, e: 100, f: 100, g: 10, h: 20, i: 30}
        a2 = {a: -100, b: -50, c: 0, g: 20, h: 30, i: 40, j: -100, k: -100, l: -100}

        expect_correlation(a1, a2, 0.9910606701839321)

        a1[:a] = 100
        expect_correlation(a1, a2, -0.37591956455252595)

        a1[:b] = 50
        expect_correlation(a1, a2, -0.7176646232366405)

        a1[:g] = 20
        expect_correlation(a1, a2, -0.6965185577824071)

        a1[:h] = 30
        expect_correlation(a1, a2, -0.6646315788560506)

        a1[:i] = 40
        expect_correlation(a1, a2, -0.6233766233766233)
      end
    end
  end

  def expect_correlation(object1, object2, correlation)
    vector1 = DbClustering::Models::Vector.new(object: object1)
    vector2 = DbClustering::Models::Vector.new(object: object2)
    expect(@cosine_similarity.correlation(vector1, vector2)).to be_within(0.001).of(correlation)
  end

  def expect_distance(object1, object2, distance)
    vector1 = DbClustering::Models::Vector.new(object: object1)
    vector2 = DbClustering::Models::Vector.new(object: object2)
    expect(@cosine_similarity.distance(vector1, vector2)).to be_within(0.001).of(distance)
  end

end
