require 'spec_helper'

describe DbClustering::DistanceMetrics::EuclideanDistance, type: :model do

  before(:each) do
    @euclidean_distance = DbClustering::DistanceMetrics::EuclideanDistance.new
  end

  describe "#distance" do

    context "using array object" do
      it "works with 6 dimensional examples" do
        a1 = [-100, -50, 0, 10, 20, 30]
        a2 = [-100, -50, 0, 20, 30, 40]

        expect_distance(a1, a2, 17.320508075688775)

        a1[0] = 100
        expect_distance(a1, a2, 200.7485989988473)

        a1[1] = 50
        expect_distance(a1, a2, 224.27661492005805)

        a1[3] = 20
        expect_distance(a1, a2, 224.0535650240808)

        a1[4] = 30
        expect_distance(a1, a2, 223.83029285599392)

        a1[5] = 40
        expect_distance(a1, a2, 223.60679774997897)
      end

      it "works with 10 dimensional example" do
        a1 = [-100, -75, -50, -25, 0, 10, 30, 50, 70, 90]
        a2 = [-100, -75, -50, -25, 0, 20, 40, 60, 80, 100]

        expect_distance(a1, a2, 22.360679774997898)

        a1[0] = 100
        expect_distance(a1, a2, 201.24611797498108)

        a1[1] = 75
        expect_distance(a1, a2, 250.99800796022265)

        a1[2] = 50
        expect_distance(a1, a2, 270.1851217221259)

        a1[3] = 25
        expect_distance(a1, a2, 274.7726332806817)

        a1[5] = 20
        expect_distance(a1, a2, 274.5906043549196)

        a1[6] = 40
        expect_distance(a1, a2, 274.40845468024486)

        a1[7] = 60
        expect_distance(a1, a2, 274.22618401604177)

        a1[8] = 80
        expect_distance(a1, a2, 274.0437921208944)

        a1[9] = 100
        expect_distance(a1, a2, 273.8612787525831)
      end

      it "works with 200 dimensional example" do
        a1 = (-100..0).to_a + (-9..90).to_a
        a2 = (-100..0).to_a + (1..100).to_a

        expect_distance(a1, a2, 100)

        a1[0] = 100
        expect_distance(a1, a2, 223.60679774997897)

        a1[1] = 99
        expect_distance(a1, a2, 298.67038688159226)

        a1[2] = 98
        expect_distance(a1, a2, 357.2394155185007)

        a1[3] = 97
        expect_distance(a1, a2, 406.5169123173106)

        (4..99).each{ |i| a1[i] = 100 - i }
        expect_distance(a1, a2, 1167.6472069936192)

        a1[101] = 1
        expect_distance(a1, a2, 1167.6043850551437)

        a1[102] = 2
        expect_distance(a1, a2, 1167.561561546114)

        a1[103] = 3
        expect_distance(a1, a2, 1167.5187364663575)

        a1[104] = 4
        expect_distance(a1, a2, 1167.4759098157015)

        (5..100).each{ |i| a1[100+i] = i }
        expect_distance(a1, a2, 1163.3572108342305)
      end
    end

    context "using hash object" do
      it "works with 6 dimensional examples" do
        a1 = {a: -100, b: -50, c: 0, d: 100, e: 100, f: 100, g: 10, h: 20, i: 30}
        a2 = {a: -100, b: -50, c: 0, g: 20, h: 30, i: 40, j: -100, k: -100, l: -100}

        expect_distance(a1, a2, 17.320508075688775)

        a1[:a] = 100
        expect_distance(a1, a2, 200.7485989988473)

        a1[:b] = 50
        expect_distance(a1, a2, 224.27661492005805)

        a1[:g] = 20
        expect_distance(a1, a2, 224.0535650240808)

        a1[:h] = 30
        expect_distance(a1, a2, 223.83029285599392)

        a1[:i] = 40
        expect_distance(a1, a2, 223.60679774997897)
      end
    end
  end

  def expect_distance(object1, object2, distance)
    vector1 = DbClustering::Models::Vector.new(object: object1)
    vector2 = DbClustering::Models::Vector.new(object: object2)
    expect(@euclidean_distance.distance(vector1, vector2)).to be_within(0.001).of(distance)
  end

end
