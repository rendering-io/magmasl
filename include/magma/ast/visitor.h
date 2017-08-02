#ifndef MAGMA_AST_VISITOR_H
#define MAGMA_AST_VISITOR_H

namespace magma { namespace ast {

class translation_unit;

/// Base class for AST visitors.
class visitor {
public:
  virtual void visit(translation_unit &) = 0;
};

}}

#endif // MAGMA_AST_VISITOR_H

