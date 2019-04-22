require 'spec_helper'

describe DbClustering::DistanceMetrics::PearsonCorrelation, type: :model do

  before(:each) do
    @pearson_correlation = DbClustering::DistanceMetrics::PearsonCorrelation.new
  end


  describe "#distance" do

    context "using array object" do

      it "works with 6 dimensional examples" do
        a1 = [-100, -50, 0, 10, 20, 30]
        a2 = [-100, -50, 0, 20, 30, 40]

        expect_distance(a1, a2, 1.0 - 0.9978980816987033)

        a1[0] = 100
        expect_distance(a1, a2, 1.0 - -0.33178189173568795)

        a1[1] = 50
        expect_distance(a1, a2, 1.0 - -0.8531546818010307)

        a1[3] = 20
        expect_distance(a1, a2, 1.0 - -0.8501701979323958)

        a1[4] = 30
        expect_distance(a1, a2, 1.0 - -0.8251789485121429)

        a1[5] = 40
        expect_distance(a1, a2, 1.0 - -0.777119205197422)
      end

    end
  end

  describe "#correlation" do

    context "using array object" do
      it "works with 6 dimensional examples" do
        a1 = [-100, -50, 0, 10, 20, 30]
        a2 = [-100, -50, 0, 20, 30, 40]

        expect_correlation(a1, a2, 0.9978980816987033)

        a1[0] = 100
        expect_correlation(a1, a2, -0.33178189173568795)

        a1[1] = 50
        expect_correlation(a1, a2, -0.8531546818010307)

        a1[3] = 20
        expect_correlation(a1, a2, -0.8501701979323958)

        a1[4] = 30
        expect_correlation(a1, a2, -0.8251789485121429)

        a1[5] = 40
        expect_correlation(a1, a2, -0.777119205197422)
      end

      it "works with 10 dimensional example" do
        a1 = [-100, -75, -50, -25, 0, 10, 30, 50, 70, 90]
        a2 = [-100, -75, -50, -25, 0, 20, 40, 60, 80, 100]

        expect_correlation(a1, a2, 0.9991021273387496)

        a1[0] = 100
        expect_correlation(a1, a2, 0.47082800718062534)

        a1[1] = 75
        expect_correlation(a1, a2, 0.1556331759412803)

        a1[2] = 50
        expect_correlation(a1, a2, -0.030429030972509225)

        a1[3] = 25
        expect_correlation(a1, a2, -0.11043152607484653)

        a1[5] = 20
        expect_correlation(a1, a2, -0.10683599418231368)

        a1[6] = 40
        expect_correlation(a1, a2, -0.09061095797872151)

        a1[7] = 60
        expect_correlation(a1, a2, -0.061965254978689745)

        a1[8] = 80
        expect_correlation(a1, a2, -0.022715542521212734)

        a1[9] = 100
        expect_correlation(a1, a2, 0.024246432248443597)
      end

      it "works with 200 dimensional example" do
        a1 = (-100..0).to_a + (-9..90).to_a
        a2 = (-100..0).to_a + (1..100).to_a

        expect_correlation(a1, a2, 0.9989178188722178)

        a1[0] = 100
        expect_correlation(a1, a2, 0.9655259356163942)

        a1[1] = 99
        expect_correlation(a1, a2, 0.9331992252857959)

        a1[2] = 98
        expect_correlation(a1, a2, 0.9018830671823298)

        a1[3] = 97
        expect_correlation(a1, a2, 0.871527012471479)

        (4..99).each{ |i| a1[i] = 100 - i }
        expect_correlation(a1, a2, -0.14729260459452256)

        a1[101] = 1
        expect_correlation(a1, a2, -0.147683155760824)

        a1[102] = 2
        expect_correlation(a1, a2, -0.14803962444596394)

        a1[103] = 3
        expect_correlation(a1, a2, -0.14836161254154293)

        a1[104] = 4
        expect_correlation(a1, a2, -0.14864872717684907)

        (5..100).each{ |i| a1[100+i] = i }
        expect_correlation(a1, a2, 0.0)
      end
    end

    context "using hash object" do
      it "works with 6 dimensional examples" do
        a1 = {a: -100, b: -50, c: 0, d: 100, e: 100, f: 100, g: 10, h: 20, i: 30}
        a2 = {a: -100, b: -50, c: 0, g: 20, h: 30, i: 40, j: -100, k: -100, l: -100}

        expect_correlation(a1, a2, 0.9978980816987033)

        a1[:a] = 100
        expect_correlation(a1, a2, -0.33178189173568795)

        a1[:b] = 50
        expect_correlation(a1, a2, -0.8531546818010307)

        a1[:g] = 20
        expect_correlation(a1, a2, -0.8501701979323958)

        a1[:h] = 30
        expect_correlation(a1, a2, -0.8251789485121429)

        a1[:i] = 40
        expect_correlation(a1, a2, -0.777119205197422)
      end
    end

  end

  def expect_correlation(object1, object2, correlation)
    vector1 = DbClustering::Models::Vector.new(object: object1)
    vector2 = DbClustering::Models::Vector.new(object: object2)
    expect(@pearson_correlation.correlation(vector1, vector2)).to be_within(0.001).of(correlation)
  end

  def expect_distance(object1, object2, distance)
    vector1 = DbClustering::Models::Vector.new(object: object1)
    vector2 = DbClustering::Models::Vector.new(object: object2)
    expect(@pearson_correlation.distance(vector1, vector2)).to be_within(0.001).of(distance)
  end

end
