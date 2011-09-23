# -*- encoding: utf-8 -*-
module Mrapper
  class Model
    attr_accessor :meta_information
    attr_accessor :result_rows
    attr_accessor :adapter

    def self.from_serializable_hash(data, options = {})
      new(data, {:adapter => Mrapper::Adapter::SerializableHash}.merge(options))
    end

    def initialize(data, options = {})
      int_options         = default_options.merge(options)
      int_data            = data

      @adapter            = int_options[:adapter]

      if( int_options[:convert_to_symbols])
        # need to create a deep copy, otherwise the data would be altered externally since references
        int_data = Marshal.load(Marshal.dump(data)).symbolize_keys_rec
      end

      @meta_information   = @adapter.meta_information(int_data, self)
      @result_rows        = @adapter.result_rows(int_data, self)
    end

    def default_options
      {
        :convert_to_symbols   => true,
        :adapter              => Mrapper::Adapter::Mongodb
      }
    end


    def serializable_hash
      {
        :meta_information      => meta_information.serializable_hash,
        :result_rows           => result_rows.collect(&:serializable_hash)
      }
    end

    def eql?(other)
      serializable_hash == other.serializable_hash
    end

    def ==(other)
      eql?(other)
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

    def eql?(other)
      serializable_hash == other.serializable_hash
    end

    def ==(other)
      eql?(other)
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

    def eql?(other)
      serializable_hash == other.serializable_hash
    end

    def ==(other)
      eql?(other)
    end
  end

  class MrEmitBase
    attr_accessor :key
    attr_accessor :value
    # TODO: those emlements should be inserted by external code and also retrieved by them,
    # TODO: somehow like a plugin
    attr_accessor :formatted_key
    attr_accessor :formatted_value
    attr_accessor :css


    def self.from_serializable_hash(params)
      raise RuntimeError.new("Need the key/value pair for key: 'key'") unless params.key?(:key)
      raise RuntimeError.new("Need the key/value pair for key: 'value'") unless params.key?(:value)

      new(
        params[:key],
        params[:value],
        :formatted_key => params[:formatted_key],
        :formatted_value => params[:formatted_value],
        :css => params[:css]
      )
    end

    def initialize(key, value, ext_options = {})
      options               = default_options.merge(ext_options)

      @key                  = key
      @value                = value
      @formatted_key        = (options[:formatted_key] || key).to_s
      @formatted_value      = options[:formatted_value] || value
      @css                  = options[:css]
    end

    def default_options
      {
        :css  => {}
      }
    end

    def serializable_hash
      {
        :key                => key,
        :value              => value,
        :formatted_key      => formatted_key,
        :formatted_value    => formatted_value,
        :css                => css
      }
    end

    def eql?(other)
      serializable_hash == other.serializable_hash
    end

    def ==(other)
      eql?(other)
    end
  end

  class MrEmitKey < MrEmitBase
  end

  class MrEmitValue < MrEmitBase
  end

  class MrMetaInformationBase
    attr_accessor :key
    attr_accessor :formatted_key

    def self.from_serializable_hash(params)
      raise RuntimeError.new("Need the key/value pair for key: 'key'") unless params.key?(:key)

      new(
          params[:key],
          params[:formatted_key]
      )
    end

    def initialize(key, formatted_key = nil)
      @key = key
      @formatted_key = (formatted_key || key).to_s
    end

    def serializable_hash
      {
        :key => key,
        :formatted_key => formatted_key
      }
    end

    def eql?(other)
      serializable_hash == other.serializable_hash
    end

    def ==(other)
      eql?(other)
    end
  end

  class MrMetaInformationKey < MrMetaInformationBase
  end

  class MrMetaInformationValue < MrMetaInformationBase
  end
end