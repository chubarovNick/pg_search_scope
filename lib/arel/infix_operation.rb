module Arel
  module Nodes

    class TextMatch < InfixOperation
      def initialize left, right
        super('@@', left, right)
      end
    end

  end
end