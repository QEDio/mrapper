# -*- encoding: utf-8 -*-
module Mrapper
  module Adapter
    class Mongodb < Base
      MR_RESULT     = :result
      MR_ID         = :'_id'
      MR_VALUE      = :value

      def self.identifier
        "MongoDB v2.0.0"
      end

      def self.meta_information(mr_result)
        MrMetaInformation.new(mr_result, self)
      end

      def self.meta_size(mr_result)
        mr_result[MR_RESULT].size
      end

      def self.result_rows(mr_result)
        result_rows   = []
        mr_result_data = mr_result[MR_RESULT]

        if !mr_result_data.nil? && mr_result_data.size > 0
          mr_result_data.each {|row| result_rows << MrRow.new(row, :adapter => self) }
        end

        return result_rows
      end

      def self.emit_key_keys(row)
        raise RuntimeError.new("Provided Parameter 'row' needs to be a hash, but is #{row.class}") if !row.is_a?(Hash)

        ret_val = []
        if row.key?(MR_ID)
          row[MR_ID].each_pair {|k,v| ret_val << MrEmitKey.new(k,v)}
        end
        return ret_val
      end

      def self.emit_value_keys(row)
        raise RuntimeError.new("Provided Parameter 'row' needs to be a hash, but is #{row.class}") if !row.is_a?(Hash)

        ret_val = []
        if row.key?(MR_VALUE)
          row[MR_VALUE].each_pair {|k,v| ret_val << MrEmitValue.new(k,v)}
        end
        return ret_val
      end

      def self.meta_emit_key_keys(mr_result)
        ret_val = []

        if !mr_result.nil? and mr_result.size > 0 and mr_result.is_a?(Hash) and mr_result.key?(MR_RESULT)
          mr_result_data = mr_result[MR_RESULT]

          if !mr_result_data.nil? and mr_result_data.size > 0
            mr_result_data.first[MR_ID].each_pair {|k,v| ret_val << MrMetaInformationKey.new(k)}
          end
        end
        return ret_val
      end

      def self.meta_emit_value_keys(mr_result)
        ret_val = []
        if !mr_result.nil? and mr_result.size > 0 and mr_result.is_a?(Hash) and mr_result.key?(MR_RESULT)
          mr_result_data = mr_result[MR_RESULT]
          if !mr_result_data.nil? and mr_result_data.size > 0
            mr_result_data.first[MR_VALUE].each_pair {|k,v| ret_val << MrMetaInformationValue.new(k)}
          end
        end
        return ret_val
      end
    end
  end
end