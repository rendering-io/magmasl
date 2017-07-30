###############################################################################
# lib/lex/CMakeLists.txt
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

BISON_TARGET(parser magma.yacc ${CMAKE_CURRENT_BINARY_DIR}/parser.c++)
FLEX_TARGET(lexer magma.lex ${CMAKE_CURRENT_BINARY_DIR}/lexer.c++)

ADD_FLEX_BISON_DEPENDENCY(lexer parser)

add_library(parse ${BISON_parser_OUTPUTS}
                  ${FLEX_lexer_OUTPUTS}
		  parser.c++
                  exprtest.c++)
target_include_directories(parse PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

