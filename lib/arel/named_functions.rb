module Arel
  module Nodes

    class TsVector < NamedFunction
      def initialize *nodes
        options = nodes.extract_options!

        document = nodes.flatten
        document = NamedFunction.new('concat_ws', document.unshift(' ')) if document.size > 1

        document = [options[:language], document] if options.has_key?(:language)

        super('to_tsvector', document)
      end
    end

    class TsQuery < NamedFunction
      OPERATORS = Hash.new('&').merge(and: '&', or: '|')

      def initialize *nodes
        options = nodes.extract_options!

        query = nodes.flatten
        query = NamedFunction.new('concat_ws', query.unshift(OPERATORS[options[:operator]])) if query.size > 1

        query = [options[:language], query] if options.has_key?(:language)

        super('to_tsquery', query)
      end
    end

  end
end