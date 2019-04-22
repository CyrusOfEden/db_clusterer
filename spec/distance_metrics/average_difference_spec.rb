require 'spec_helper'

describe DbClustering::DistanceMetrics::AverageDifference, type: :model do

  before(:each) do
    @average_difference = DbClustering::DistanceMetrics::AverageDifference.new
  end

  describe "#distance" do

    context "using array object" do

      it "works with 6 dimensional examples" do
        a1 = [-100, -50, 0, 10, 20, 30]
        a2 = [-100, -50, 0, 20, 30, 40]

        expect_distance(a1, a2, 5.0)

        a1[0] = 100
        expect_distance(a1, a2, 38.333333333333336)

        a1[1] = 50
        expect_distance(a1, a2, 55)

        a1[3] = 20
        expect_distance(a1, a2, 53.333333333333333)

        a1[4] = 30
        expect_distance(a1, a2, 51.666666666666664)

        a1[5] = 40
        expect_distance(a1, a2, 50)
      end

    end
  end

  def expect_distance(object1, object2, distance)
    vector1 = DbClustering::Models::Vector.new(object: object1)
    vector2 = DbClustering::Models::Vector.new(object: object2)
    expect(@average_difference.distance(vector1, vector2)).to be_within(0.001).of(distance)
  end

end
