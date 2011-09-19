# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'

# TODO: test each Model.rb class on its own
class TestBuilder < Test::Unit::TestCase
  context "building a model from a mongdob mapreduce result" do
    setup do
      @wrapper_model = Mrapper::Model.new(MONGODB_MR_RESULT)
    end

    context "looking at the metainformation" do
      setup do
        @meta_information = @wrapper_model.meta_information
      end
    
      should "have the correct row size" do
        assert_equal 22, @meta_information.nr_rows
      end

      should "have the correct emit key keys information" do
        assert_equal MODEL_MONDGODB_RESULT_EMIT_KEY_KEYS, @meta_information.serializable_hash[:emit_key_keys]
      end

      should "have the correct emit value keys information" do
        assert_equal MODEL_MONDGODB_RESULT_EMIT_VALUE_KEYS, @meta_information.serializable_hash[:emit_value_keys]
      end
    end

    context "looking at the map reduce rows" do
      setup do
        @result_rows = @wrapper_model.result_rows
        @meta_information = @wrapper_model.meta_information
      end

      should "have the same number of rows as mentionend in the meta-information" do
        assert_equal @meta_information.nr_rows, @result_rows.size
      end

      should "have the correct first result row" do
        assert_equal MODEL_MONGODB_RESULT_FIRST_ROW, @result_rows.first.serializable_hash
      end

      context "and now specifically at the first row entry it" do
        setup do
          @row = @result_rows.first
        end

        should "have the correct emit_keys" do
          assert_equal 1, @row.mr_emit_keys.size
          assert_equal MODEL_MONGODB_RESULT_FIRST_ROW_KEYS, @row.serializable_hash[:mr_emit_keys]
          assert_equal MODEL_MONGODB_RESULT_FIRST_ROW_VALUES, @row.serializable_hash[:mr_emit_values]
        end
      end
    end

    context "building a model from an empty mr result" do
      should "return a model that works" do
        model = Mrapper::Model.new(MONGODB_EMPTY_MR_RESULT)

        assert_equal MODEL_MONGODB_EMPTY_MR_RESULT_METAINFORMATION, model.meta_information.serializable_hash
        assert_equal MODEL_MONGODB_EMPTY_MR_RESULT_RESULT_ROWS, model.result_rows
      end
    end

    context "building a new model from it's own serializable_hash" do
      setup do
        @wrapper_model = Mrapper::Model.new(MONGODB_MR_RESULT)
      end

      context "and looking into the metainformation" do
        setup do
          @meta_information       = @wrapper_model.meta_information
          @new_meta_information   = Mrapper::Model.from_serializable_hash(@wrapper_model.serializable_hash).meta_information
        end

        should "return the same size" do
          assert_equal @meta_information.nr_rows, @new_meta_information.nr_rows
        end

        should "return the same emit keys" do
          assert_equal @meta_information.serializable_hash[:emit_key_keys], @new_meta_information.serializable_hash[:emit_key_keys]
        end

        should "return the same value keys" do
          assert_equal @meta_information.serializable_hash[:emit_value_keys], @new_meta_information.serializable_hash[:emit_value_keys]
        end
      end

      context "and looking at the result rows" do
        setup do
          @result_rows            = @wrapper_model.serializable_hash[:result_rows]
          @new_result_rows        = Mrapper::Model.from_serializable_hash(@wrapper_model.serializable_hash).serializable_hash[:result_rows]
        end

        should "return the same result row data" do
          assert_equal @result_rows, @new_result_rows
        end
      end
    end
  end
end