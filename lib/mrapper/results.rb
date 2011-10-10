# -*- encoding: utf-8 -*-
require 'bzip2'

module Mrapper
  class Results
    attr_accessor :results

    def self.from_serializable_hash(hsh)
      new(hsh)
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

      if( !data.nil? && options[:convert_to_symbols] )
        # need to create a deep copy, otherwise the data would be altered externally since references
        data = Marshal.load(Marshal.dump(data)).symbolize_keys_rec
      end

      add_results(data[:results]) if( data && data[:results] )
    end

    def default_options
      {
        :convert_to_symbols   => true,
        :results      => []
      }
    end

    def serializable_hash
      {
        :results    => results.collect(&:serializable_hash)
      }
    end

    def json
      Yajl::Encoder.encode(serializable_hash)
    end

    def add_results(results)
      Array(results).each do |result|
        add_result(result)
      end
    end

    def add_result(result)

      unless( result.nil? )
        if( result.is_a?(Model) )
          results << result
        elsif( result.is_a?(Hash) )
          results << Model.from_serializable_hash(result)
        else
          puts "result: #{result.inspect}"
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