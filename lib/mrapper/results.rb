# -*- encoding: utf-8 -*-
require 'bzip2'

module Mrapper
  class Results
    attr_accessor :results
    attr_accessor :id
    # sub_id is the part thats different for each model with the same general query
    attr_accessor :sub_id
    attr_accessor :result_meta_info

    def self.from_serializable_hash(hsh, options = {})
      new(hsh, options)
    end

    def self.from_json(json)
      from_serializable_hash(Yajl::Parser.parse(json))
    end

    def self.from_compressed(data)
      from_json(Bzip2.uncompress(data))
    end

    def initialize(ext_data = nil, ext_options = {})
      options       = default_options.merge(ext_options)
      data          = ext_data

      # initialize with default values
      @results            = options[:results]
      @id                 = options[:id]
      @sub_id             = options[:sub_id]
      @result_meta_info   = options[:result_meta_info_ext]

      # deep copy requested,
      # ATTENTION: This will be slow!
      if !data.nil? && options[:deep_copy]
        data = Marshal.load(Marshal.dump(data))
      end

      if !data.nil? && options[:convert_to_symbols]
        data = data.symbolize_keys_rec
      end

      if data
        add_results( data[:results]||data["results"], options )  if( data[:results] || data["results"] )

        @id             = data[:id] || data["id"]
        @sub_id         = data[:sub_id] || data["sub_id"]
      end
    end

    # default setting are the slowest, but safest
    def default_options
      {
        :convert_to_symbols   => true,
        :deep_copy            => true,
        :results              => [],
        :result_meta_info_ext => {order: [], data: {}}
      }
    end

    def serializable_hash
      {
        :results                => results.collect(&:serializable_hash),
        :result_meta_info_ext   => result_meta_info_ext,
        :id                     => id,
        :sub_id                 => sub_id,
        :type                   => self.class.to_s
      }
    end

    def json
      Yajl::Encoder.encode(serializable_hash)
    end

    def add_results(results, ext_options = {})
      options       = default_add_results_options.merge(extract_options_for_add_results(ext_options))

      Array(results).each do |result|
        add_result(result, options)
      end
    end

    def default_add_results_options
      {
        :convert_to_symbols => false,
        :deep_copy          => false
      }
    end

    def result_meta_info_ext
      {
        orig: @result_meta_info,
        tupel: generate_tupel()
      }
    end

    def generate_tupel()
      data    = @result_meta_info[:data]
      order   = @result_meta_info[:order]
      arr     = []

      generate_tupel_rec(order, data, '', arr)
      return arr
    end

    def generate_tupel_rec(order, data, str, arr)
      if order.blank? || order[0].blank?
        arr << str[0..-2]
        return
      end

      data[order[0]].each do |d|
        s = generate_tupel_rec(order[1..-1], data, d.to_s + '_' + str, arr)
      end
    end

    # yeah, currently just nothing, probably overkill again
    def extract_options_for_add_results(ext_options)
      options = {}

      return options
    end

    def add_result(result, options)
      unless result.nil?
        if result.is_a?(Model)
          results << result
          extract_meta_information(result)
        elsif result.is_a?(Results)
          #results << result
          raise "Me I dont want to nest results within results"
        elsif result.is_a?(Hash)
          if result[:type].eql?(self.class.to_s)
            results << self.class.from_serializable_hash(result)
          else
            results << Model.from_serializable_hash(result, options)
          end
        else
          raise Exception.new("I'm sorry but I don't know how to deserialize the datatype #{result.class} for result")
        end
      end
    end

    def extract_meta_information(result)
      result.result_rows.each do |r|
        r.mr_emit_keys.each do |emit_key|
          @result_meta_info[:data][emit_key.key] ||= []
          @result_meta_info[:data][emit_key.key] << emit_key.value if !@result_meta_info[:data][emit_key.key].include?(emit_key.value)

          @result_meta_info[:order] << emit_key.key if !@result_meta_info[:order].include?(emit_key.key)
        end
      end

      return true
    end

    def compress
      Bzip2.compress(json)
    end

    def eql?(other)
      serializable_hash == other.serializable_hash
    end

    def ==(other)
      eql?(other)
    end

    # TODO: the id, subid and what not needs be better, so we can easily match results/models together
    def merge!(other, ext_columns, ext_options = {})
      options = default_merge_options.merge(ext_options)

      columns = Array(ext_columns)
      raise Exception.new("No merge can be performed if the columns to merge are unknown!") if columns.size == 0

      results.each_with_index do |result, i|
        result.merge!(other.results[i], columns, options)
      end
    end

    def default_merge_options
      {
        :replace_if_not_found => true,
        :replace_with_if_not_found => 0
      }
    end
  end
end