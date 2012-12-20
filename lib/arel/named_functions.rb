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

  end
end