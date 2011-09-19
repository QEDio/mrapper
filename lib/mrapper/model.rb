# -*- encoding: utf-8 -*-
module Mrapper
  class Model
    attr_accessor :meta_information
    attr_accessor :mr_result_rows
    attr_accessor :adapter

    def initialize(mr_result, options = {} )
      @adapter          = options[:adapter] || Mrapper::Adapter::Mongodb

      @meta_information = @adapter.meta_information(mr_result, self)
      @mr_result_rows  = @adapter.result_rows(mr_result, self)
    end

    def serializable_hash
      {
        :meta_information         => meta_information.serializable_hash,
        :mr_result_rows           => mr_result_rows.collect(&:serializable_hash)
      }
    end
  end

  class MrMetaInformation
    attr_accessor :emit_key_keys, :emit_value_keys
    attr_accessor :nr_rows

    def initialize(mr_result, model)
      @emit_key_keys      = model.adapter.meta_emit_key_keys(mr_result)
      @emit_value_keys    = model.adapter.meta_emit_value_keys(mr_result)
      @nr_rows            = model.adapter.meta_size(mr_result)
    end

    def serializable_hash
      {
        :emit_key_keys          => emit_key_keys.collect(&:serializable_hash),
        :emit_value_keys        => emit_value_keys.collect(&:serializable_hash),
        :nr_rows                => nr_rows
      }
    end
  end

  class MrRow
    attr_accessor :mr_emit_keys
    attr_accessor :mr_emit_values

    def initialize(row, model)
      @mr_emit_keys       = model.adapter.emit_key_keys(row)
      @mr_emit_values     = model.adapter.emit_value_keys(row)
    end

    def serializable_hash
      {
        :mr_emit_keys       => mr_emit_keys.collect(&:serializable_hash),
        :mr_emit_values     => mr_emit_values.collect(&:serializable_hash)
      }
    end
  end

  class MrEmitBase
    attr_accessor :key
    attr_accessor :value
    attr_accessor :formatted_key
    attr_accessor :formatted_value

    def initialize(key, value, formatted_key = nil, formatted_value = nil)
      @key                  = key
      @value                = value
      @formatted_key        = formatted_key || key
      @formatted_value      = formatted_value || value
    end

    def serializable_hash
      {
          :key                => key,
          :value              => value,
          :formatted_key      => formatted_key,
          :formatted_value    => formatted_value
      }
    end
  end

  class MrEmitKey < MrEmitBase
  end

  class MrEmitValue < MrEmitBase
  end

  class MrMetaInformationBase
    attr_accessor :key
    attr_accessor :formatted_key

    def initialize(key, formatted_key = nil)
      @key = key
      @formatted_key = formatted_key || key
    end

    def serializable_hash
      {
        :key => key,
        :formatted_key => formatted_key
      }
    end
  end

  class MrMetaInformationKey < MrMetaInformationBase
  end

  class MrMetaInformationValue < MrMetaInformationBase
  end
end