#ifndef MAGMA_AST_NODE_H
#define MAGMA_AST_NODE_H

namespace magma { namespace ast {

class visitor;

/// Base class for AST nodes.
class node {
protected:
  node();

public:
  virtual ~node();
  virtual void accept(visitor &) = 0;
};

}}

#endif // MAGMA_AST_NODE_H

