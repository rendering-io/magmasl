#ifndef MAGMA_AST_TRANSLATIONUNIT_H
#define MAGMA_AST_TRANSLATIONUNIT_H

#include "node.h"

namespace magma { namespace ast {

/// AST node representing a complete translation unit.
class translation_unit : public node {
public:
  static auto create() -> std::unique_ptr<translation_unit>;

  void accept(visitor &) override;
};

}}

#endif // MAGMA_AST_TRANSLATIONUNIT_H

