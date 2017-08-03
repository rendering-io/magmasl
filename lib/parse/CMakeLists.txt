###############################################################################
# lib/lex/CMakeLists.txt
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

# Build a bison parser.
BISON_TARGET(parser magma.yacc ${CMAKE_CURRENT_BINARY_DIR}/parser.c++)

# Patch the bison header so that std::unique_ptr works properly.
add_custom_command(OUTPUT ${BISON_parser_OUTPUT_HEADER}
	COMMAND sed -i -f yacc.sed ${BISON_parser_OUTPUT_HEADER}
        VERBATIM	
        APPEND)

# Build a flex parser.
FLEX_TARGET(lexer magma.lex ${CMAKE_CURRENT_BINARY_DIR}/lexer.c++)

# Add lexer dependency on parser for token definitions.
ADD_FLEX_BISON_DEPENDENCY(lexer parser)

# Build the parser library.
add_library(parse ${BISON_parser_OUTPUTS}
                  ${FLEX_lexer_OUTPUTS}
		  parser.c++
                  exprtest.c++)
target_include_directories(parse PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(parse PUBLIC ast)

