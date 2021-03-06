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

      if !data.nil? && options[:deep_copy]
        data = Marshal.load(Marshal.dump(data))
      end
      
      if options[:convert_to_symbols]
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


    # TODO: Merge needs to be a little better
    # TODO: consider merging a model with different results, the results from the 'other' would not be in the merged model
    # TODO: this is not so good, because its not a merge, its a replace if found, otherwise do nothing :(
    def merge!(other, ext_columns, ext_options = {})
      options = default_merge_options.merge(ext_options)

      columns = Array(ext_columns)
      raise Exception.new("No merge can be performed if the columns to merge are unknown!") if columns.size == 0
      
      result_rows.each do |row|
        other_row = other.get_row(row, columns)

        if !other_row.nil?
          row.merge!(other_row, columns)
        else
          if options[:replace_if_not_found]
            row.mr_emit_values.each do |column|
              if columns.include?(column.key)
                column.value = options[:replace_with_if_not_found]
              end
            end
          end
        end
      end
    end

    def default_merge_options
      {
        :replace_if_not_found => true,
        :replace_with_if_not_found => 0
      }
    end

    def get_row(row, columns = nil)
      eql_rows = result_rows.select{|r| r.eql1?(row, columns)}
      raise Exception.new("This cant be, there are #{eql_rows.size} that are eql to the provided row! Don't toy with me") if eql_rows.size > 1
      eql_rows[0]
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
    attr_accessor :mr_emit_keys, :mr_emit_values, :adapter

    def initialize(row, ext_options = {})
      options             = default_options.merge(ext_options)

      @adapter            = options[:adapter]
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
      }
    end

    def eql?(other)
      serializable_hash == other.serializable_hash
    end

    def ==(other)
      eql?(other)
    end

    def merge!(other, columns)
      mr_emit_values.each do |column|
        if columns.include?(column.key)
          other_column = other.get_emit_value(column)
          column.value = other_column.value
        end
      end
    end

    # TODO: name
    # returns true if:
    #   * all columns are present, if columns is nil all columns must match, if empty arry, non must must match
    #   * the mr_emit_keys are the same
    def eql1?(other, columns = nil)
      equal = true

      other.mr_emit_keys.each do |emit_key|
        equal = has_emit_key?(emit_key)
        break if equal == false
      end

      if equal
        # every column must be present!
        if columns.nil?
          columns = mr_emit_values.map{|ev|ev.key}
        end

        other.mr_emit_values.each do |emit_value|
          next if !columns.include?(emit_value.key)
          #puts "key: #{emit_value.key}"
          equal = has_emit_value?(emit_value)
          break if equal == false
        end
      end

      equal
    end

    def get_emit_key(emit_key)
      emit_key = mr_emit_keys.select{|ek| ek.eql1?(emit_key)}
      raise Exception.new("Boy this is not allowed. There are #{emit_key.size} emit_keys for emit_key #{emit_key.inspect}") if emit_key.size > 1
      return emit_key[0]
    end

    def has_emit_key?(emit_key)
      !get_emit_key(emit_key).nil?
    end

    def get_emit_value(emit_value)
      emit_value = mr_emit_values.select{|ev| ev.eql1?(emit_value)}
      raise Exception.new("Boy this is not allowed. There are #{emit_value.size} emit_values for emit_value #{emit_value.inspect}") if emit_value.size > 1
      return emit_value[0]
    end

    def has_emit_value?(emit_value)
      !get_emit_value(emit_value).nil?
    end
  end

  class MrEmitBase
    attr_accessor :key, :formatted_key
    attr_reader   :value, :formatted_value
    # TODO: those emlements should be inserted by external code and also retrieved by them,
    # TODO: somehow like a plugin
    attr_accessor :css

    def self.from_serializable_hash(params)
      raise RuntimeError.new("Need the key/value pair for key: 'key'") unless params.key?(:key)
      raise RuntimeError.new("Need the key/value pair for key: 'value'") unless params.key?(:value)

      new(
        params[:key],
        params[:value],
        :formatted_key      => params[:formatted_key],
        :formatted_value    => params[:formatted_value],
      )
    end

    def initialize(key, value, ext_options = {})
      options               = default_options.merge(ext_options)

      self.key                  = key.to_s.to_sym
      self.value                = value
      self.formatted_key        = (options[:formatted_key] || key).to_s
      self.formatted_value      = options[:formatted_value] || value
      # TODO: is there a better way to avoid getting nil for @css if :css => nil is passed in ext_options?
      @css                  = options[:css] || default_options[:css]
    end

    def default_options
      {
      }
    end

    def value=(v)
      if v.is_a?(Float)
        # check for infinity and convert to NaN
        if v.eql?(Float::INFINITY) || v.nan?
          v = 0
        end
      end

      @value = v
    end

    def formatted_value=(v)
      if v.is_a?(Float)
        # check for infinity and convert to NaN
        if v.eql?(Float::INFINITY) || v.nan?
          v = 0
        end
      end

      @formatted_value = v
    end

    def serializable_hash
      {
        :key                => key,
        :value              => value,
        #:formatted_key      => formatted_key,
        #:formatted_value    => formatted_value,
      }
    end

    def eql?(other)
      serializable_hash == other.serializable_hash
    end

    def ==(other)
      eql?(other)
    end

    def eql1?(other)
      other.key.eql?(key) && other.value.eql?(value)
    end
  end

  class MrEmitKey < MrEmitBase
  end

  class MrEmitValue < MrEmitBase
    def eql1?(other)
      other.key.eql?(key)
    end
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
        :key            => key,
        #:formatted_key  => formatted_key
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