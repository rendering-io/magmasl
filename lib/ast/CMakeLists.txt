###############################################################################
# lib/ast/CMakeLists.txt
set(SOURCES node.c++
            translation_unit.c++
            visitor.c++)
add_library(ast ${SOURCES})

