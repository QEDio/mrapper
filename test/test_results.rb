# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'

# TODO: test each Model.rb class on its own
class TestResults < Test::Unit::TestCase
  context "building an empty results-object" do
    setup do
      @results = Mrapper::Results.new()
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
end