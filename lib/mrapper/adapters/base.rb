# -*- encoding: utf-8 -*-
module Mrapper
  module Adapter
    class Base
      def self.identifier
        raise RuntimeError.new("Implement me")
      end

      def self.meta_information(mr_result, model)
        raise RuntimeError.new("Implement me")
      end

      def self.meta_size(mr_result)
        raise RuntimeError.new("Implement me")
      end

      def self.result_rows(mr_result, model)
        raise RuntimeError.new("Implement me")
      end

      def self.emit_key_keys(row)
        raise RuntimeError.new("Implement me")
      end

      def self.emit_value_keys(row)
        raise RuntimeError.new("Implement me")
      end

      def self.meta_emit_key_keys(mr_result)
        raise RuntimeError.new("Implement me")
      end

      def self.meta_emit_value_keys(mr_result)
        raise RuntimeError.new("Implement me")
      end
    end
  end
end