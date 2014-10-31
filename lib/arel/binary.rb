module Arel
  module Nodes
    class Convert < Binary
    end
  end
end

module Arel
  module Visitors
    class ToSql < Arel::Visitors::Reduce
      def visit_Arel_Nodes_Convert o
        "(#{visit o.left})::#{o.right}"
      end
    end
  end
end
