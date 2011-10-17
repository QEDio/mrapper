# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'

# TODO: test each Model.rb class on its own
class TestResults < Test::Unit::TestCase
  context "building an empty results-object" do
    setup do
      @results          = Mrapper::Results.new()
      @results.id       = "abc"
      @results.sub_id   = "xyz"
    end

    should "set the id" do
      assert_equal "abc", @results.id
    end

    should "set the sub_id" do
      assert_equal "xyz", @results.sub_id
    end

    should "have no models within" do
      assert_equal 0, @results.results.size
    end

    context "adding 10 model objects" do
      setup do
        10.times do |i|
          @results.results << Mrapper::Model.new(MONGODB_MR_RESULT)
        end
      end

      should "add 10 models to the results" do
        assert_equal 10, @results.results.size
      end

      should "serialize the result and back again" do
        assert_equal @results, Mrapper::Results.from_serializable_hash(@results.serializable_hash)
      end

      should "serialize to json and back again" do
        assert_equal @results, Mrapper::Results.from_json(@results.json)
      end

      should "compress and back" do
        assert_equal @results, Mrapper::Results.from_compressed(@results.compress)
      end
    end
  end

  context "the result model can add itself to it's list of results and" do
    setup do
      @wm         = Mrapper::Model.new(MONGODB_MR_RESULT)
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