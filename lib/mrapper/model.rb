# -*- encoding: utf-8 -*-
module Mrapper
  class Model
    attr_accessor :meta_information
    attr_accessor :result_rows
    attr_accessor :adapter
    # sub_id is the part thats different for each model with the same general query
    attr_accessor :sub_id
    attr_accessor :id

    def self.from_serializable_hash(data, options = {})
      new(data, {:adapter => Mrapper::Adapter::SerializableHash}.merge(options))
    end

    def initialize(ext_data, ext_options = {})
      options         = default_options.merge(ext_options)
      data            = ext_data

      @adapter        = options[:adapter]
      # TODO: this is such a crap
      # TODO: this all needs to be much better suited for paramter passing
      @id             = data[:id] || data["id"] || options[:id] || options["id"]
      @sub_id         = data[:sub_id] || data["sub_id"] || options[:sub_id] || options["sub_id"]

      if( !data.nil? && options[:deep_copy] )
        data = Marshal.load(Marshal.dump(data))
      end
      
      if( options[:convert_to_symbols])
        data = data.symbolize_keys_rec
      end
      
      @meta_information   = adapter.meta_information(data)
      @result_rows        = adapter.result_rows(data)
    end

    # default setting are the slowest, but safest
    def default_options
      {
        :convert_to_symbols   => true,
        :deep_copy            => true,
        :adapter              => Mrapper::Adapter::Mongodb,
        :id                   => nil,
        :sub_id               => nil
      }
    end

    def serializable_hash
      {
        :meta_information      => meta_information.serializable_hash,
        :result_rows           => result_rows.collect(&:serializable_hash),
        :id                    => id,
        :sub_id                => sub_id
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

    def initialize(mr_result, adapter)
      @emit_key_keys      = adapter.meta_emit_key_keys(mr_result)
      @emit_value_keys    = adapter.meta_emit_value_keys(mr_result)
      @nr_rows            = adapter.meta_size(mr_result)
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
    attr_accessor :mr_emit_keys, :mr_emit_values, :adapter, :bollinger

    def initialize(row, ext_options = {})
      options             = default_options.merge(ext_options)

      @adapter            = options[:adapter]
      # this is not in the spirit of adapters
      @bollinger          = row[:bollinger] rescue ''
      @mr_emit_keys       = adapter.emit_key_keys(row)
      @mr_emit_values     = adapter.emit_value_keys(row)
    end

    def default_options
      {
        :adapter              => Mrapper::Adapter::Mongodb
      }
    end

    def serializable_hash
      {
        :mr_emit_keys       => mr_emit_keys.collect(&:serializable_hash),
        :mr_emit_values     => mr_emit_values.collect(&:serializable_hash),
        :bollinger          => bollinger
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
    #attr_accessor :derived_values


    def self.from_serializable_hash(params)
      raise RuntimeError.new("Need the key/value pair for key: 'key'") unless params.key?(:key)
      raise RuntimeError.new("Need the key/value pair for key: 'value'") unless params.key?(:value)

      new(
        params[:key],
        params[:value],
        :formatted_key      => params[:formatted_key],
        :formatted_value    => params[:formatted_value],
        :css                => params[:css],
        #:derived_values     => params[:derived_values]
      )
    end

    def initialize(key, value, ext_options = {})
      options               = default_options.merge(ext_options)

      @key                  = key.to_s.to_sym
      @value                = value
      @formatted_key        = (options[:formatted_key] || key).to_s
      @formatted_value      = options[:formatted_value] || value
      # TODO: is there a better way to avoid getting nil for @css if :css => nil is passed in ext_options?
      @css                  = options[:css] || default_options[:css]
      #@derived_values       = options[:derived_values] || default_options[:derived_values]
    end

    def default_options
      {
        :css            => {},
        #:derived_values => {}
      }
    end

    def serializable_hash
      {
        :key                => key,
        :value              => value,
        :formatted_key      => formatted_key,
        :formatted_value    => formatted_value,
        :css                => css,
        #:derived_values     => derived_values
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
      @key = key.to_s.to_sym
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