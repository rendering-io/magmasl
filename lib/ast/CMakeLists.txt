###############################################################################
# lib/ast/CMakeLists.txt
set(SOURCES decl.c++
            node.c++
            translation_unit.c++
            visitor.c++)
add_library(ast ${SOURCES})

