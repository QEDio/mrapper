# -*- encoding: utf-8 -*-
require 'bzip2'

module Mrapper
  class Results
    attr_accessor :results

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

      @results      = options[:results]

      # deep copy requested,
      # ATTENTION: This will be slow!
      if( !data.nil? && options[:deep_copy] )
        data = Marshal.load(Marshal.dump(data))
      end

      if( !data.nil? && options[:convert_to_symbols] )
        data = data.symbolize_keys_rec
      end

      add_results(data[:results], options) if( data && data[:results] )
    end

    # default setting are the slowest, but safest
    def default_options
      {
        :convert_to_symbols   => true,
        :deep_copy            => true,
        :results      => []
      }
    end

    def serializable_hash
      {
        :results    => results.collect(&:serializable_hash),
        :type       => self.class.to_s
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

    # yeah, currently just nothing, probably overkill again
    def extract_options_for_add_results(ext_options)
      options = {}

      return options
    end

    def add_result(result, options)
      unless( result.nil? )
        if( result.is_a?(Model) )
          results << result
        elsif( result.is_a?(Results) )
          results << result
        elsif( result.is_a?(Hash) )
          if( result[:type].eql?(self.class.to_s))
            results << self.class.from_serializable_hash(result)
          else
            results << Model.from_serializable_hash(result, options)
          end
        else
          raise Exception.new("I'm sorry but I don't know how to deserialize the datatype #{result.class} for result")
        end
      end
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
  end
end