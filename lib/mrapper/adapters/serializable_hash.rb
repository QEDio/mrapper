# -*- encoding: utf-8 -*-
module Mrapper
  module Adapter
    META_INFORMATION      = :meta_information
    EMIT_KEY_KEYS         = :emit_key_keys
    EMIT_VALUE_KEYS       = :emit_value_keys
    RESULT_ROWS           = :result_rows
    MR_EMIT_VALUES        = :mr_emit_values
    MR_EMIT_KEYS          = :mr_emit_keys
    KEY                   = :key
    VALUE                 = :value
    FORMATTED_KEY         = :formatted_key
    FORMATTED_VALUE       = :formatted_value

    class SerializableHash < Base
      def self.identifier
        "Internal Serializable Hash v1"
      end

      def self.meta_information(mr_result)
        MrMetaInformation.new(mr_result, self)
      end

      def self.meta_size(mr_result)
        mr_result[META_INFORMATION][:nr_rows]
      end

      def self.result_rows(mr_result)
        result_rows = []
        data = mr_result[RESULT_ROWS]

        if !data.nil? && data.size > 0
          result_rows = data.collect{|row| MrRow.new(row, :adapter => self)}
        end

        return result_rows
      end

      def self.emit_key_keys(row)
        emit_base(row, MR_EMIT_KEYS, MrEmitKey)
      end

      def self.emit_value_keys(row)
        emit_base(row, MR_EMIT_VALUES, MrEmitValue)
      end

      def self.emit_base(row, accessor, build_class)
        raise RuntimeError.new("Provided Parameter 'row' needs to be a hash, but is #{row.class}") if !row.is_a?(Hash)

        ret_val = []
        if row.key?(accessor)
          ret_val = row[accessor].collect{|emit_value| build_class.from_serializable_hash(emit_value)}
        end
        return ret_val
      end

      def self.meta_emit_key_keys(mr_result)
        meta_emit_base(mr_result, EMIT_KEY_KEYS, MrMetaInformationKey)
      end

      def self.meta_emit_value_keys(mr_result)
        meta_emit_base(mr_result, EMIT_VALUE_KEYS, MrMetaInformationValue)
      end

      def self.meta_emit_base(data, value_accessor, build_class)
        ret_val = []

        if !data.nil? and data.is_a?(Hash) and data.size > 0 and data.key?(META_INFORMATION)
          meta_data = data[META_INFORMATION]

          if meta_data.key?(value_accessor)
            ret_val = meta_data[value_accessor].collect{|emit_value_key| build_class.from_serializable_hash( emit_value_key )}
          end
        end
        return ret_val
      end
    end
  end
end