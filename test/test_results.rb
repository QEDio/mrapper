# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'

# TODO: test each Model.rb class on its own
class TestResults < Test::Unit::TestCase
  context "building an empty results-object" do
    setup do
      @r_r1_1          = Mrapper::Results.new()
      @r_r1_1.id       = "abc"
      @r_r1_1.sub_id   = "xyz"

      @r_r1_2          = Mrapper::Results.new()
      @r_r1_2.id       = "abc"
      @r_r1_2.sub_id   = "xyz"
    end

    should "set the id" do
      assert_equal "abc", @r_r1_1.id
    end

    should "set the sub_id" do
      assert_equal "xyz", @r_r1_1.sub_id
    end

    should "have no models within" do
      assert_equal 0, @r_r1_1.results.size
    end

    context "adding 10 model objects" do
      setup do
        10.times do |i|
          @r_r1_1.results << Mrapper::Model.new(MONGODB_MR_RESULT1)
          @r_r1_2.results << Mrapper::Model.new(MONGODB_MR_RESULT1)
        end
      end

      should "add 10 models to the results" do
        assert_equal 10, @r_r1_1.results.size
      end

      should "serialize the result and back again" do
        assert_equal @r_r1_1, Mrapper::Results.from_serializable_hash(@r_r1_1.serializable_hash)
      end

      should "serialize to json and back again" do
        assert_equal @r_r1_1, Mrapper::Results.from_json(@r_r1_1.json)
      end

      should "compress and back" do
        assert_equal @r_r1_1, Mrapper::Results.from_compressed(@r_r1_1.compress)
      end

      context "and merging it with another result object" do
        setup do
          @merge_columns = [:conversions, :clicks]
          @r_r2_1 = Mrapper::Results.new()
          10.times do |i|
            @r_r2_1.results << Mrapper::Model.new(MONGODB_MR_RESULT2)
          end
        end

        should "perform a successfull merge" do
          @r_r1_1.merge!(@r_r2_1, @merge_columns)
          assert_not_equal @r_r1_1, @r_r1_2
          assert_not_equal @r_r1_1, @r_r2_1

          @r_r1_1.results.each_with_index do |m1, i|
            check_merged_model(m1, @r_r2_1.results[i], @merge_columns)
          end
        end
      end
    end
  end

  context "the result model can add itself to it's list of results and" do
    setup do
      @wm         = Mrapper::Model.new(MONGODB_MR_RESULT1)
      @wm.id      = "abc"
      @wm.sub_id  = "xyz"

      @r1 = Mrapper::Results.new()
      @r1.add_results(@wm)

      @r2 = Mrapper::Results.new()
      @r2.add_results(@r1)
    end

    should "should de/serialize perfectly" do
      assert_equal @r2, Mrapper::Results.from_serializable_hash(@r2.serializable_hash)
    end
  end

  context "build the result model from hash params" do
    setup do
      @r       = Mrapper::Results.new(:id => "abc", :sub_id => "xyz")
    end

    should "return the correct value for id" do
      assert_equal "abc", @r.id
    end

    should "return the correct value for sub_id" do
      assert_equal "xyz", @r.sub_id
    end
  end
end