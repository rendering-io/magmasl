#include <magma/ast/translation_unit.h>
#include <magma/ast/visitor.h>

namespace magma { namespace ast {

auto translation_unit::create() -> std::unique_ptr<translation_unit> {
  return std::make_unique<translation_unit>();
}

void translation_unit::accept(visitor &v) {
  v.visit(*this);
}

}}

