/* $Id$ -*- mode: c++ -*- */
/** \file parser.yy Contains the example Bison parser source */

%{ /*** C/C++ Declarations ***/

#include <fstream>
#include <stdio.h>
#include <string>
#include <vector>

#include "expression.h"

#include <magma/parse/parser.h>
%}

/*** yacc/bison Declarations ***/

/* Require bison 2.3 or later */
%require "3.0.4"

/* add debug output code to generated parser. disable this for release
 * versions. */
%debug

/* start symbol is named "module" */
%start module

/* write out a header file containing the token defines */
%defines

/* use newer C++ skeleton file */
%skeleton "lalr1.cc"

/* namespace to enclose parser in */
%name-prefix="example"

/* set the parser's class identifier */
%define "parser_class_name" "Parser"
%define api.namespace {magma::yacc}

/* keep track of the current position within the input */
%locations

/**
 * Run before parsing starts.
 */
%initial-action
{
  // initialize the initial location object
  @$.begin.filename = @$.end.filename = &driver.path_;
};

/* The driver is passed by reference to the parser and to the scanner. This
 * provides a simple but effective pure interface, not relying on global
 * variables. */
%param { magma::parse::parser& driver }

/* verbose error messages */
%error-verbose

 /*** BEGIN EXAMPLE - Change the example grammar's tokens below ***/

%union {
    int  			integerVal;
    double 			doubleVal;
    std::string*		stringVal;
    class CalcNode*		calcnode;
}

%token			END	     0	"end of file"
%token			IDENTIFIER	"identifier"
%token			FN		"fn"
%token                  LPAREN		"("
%token			RPAREN		")"
%token			LBRACE		"{"
%token			RBRACE		"}"
%token <integerVal> 	INTEGER		"integer"
%token <doubleVal> 	DOUBLE		"double"
%token <stringVal> 	STRING		"string"

%type <calcnode>	constant variable
%type <calcnode>	atomexpr powexpr unaryexpr mulexpr addexpr expr

%destructor { delete $$; } STRING
%destructor { delete $$; } constant variable
%destructor { delete $$; } atomexpr powexpr unaryexpr mulexpr addexpr expr

 /*** END EXAMPLE - Change the example grammar's tokens above ***/

%{

#include "driver.h"
#include "scanner.h"

/* this "connects" the bison parser in the driver to the flex scanner class
 * object. it defines the yylex() function call to pull the next token from the
 * current lexer object of the driver context. */
#undef yylex
#define yylex reinterpret_cast<example::Scanner*>(driver.lexer)->lex

%}

%% /*** Grammar Rules ***/

 /*** BEGIN EXAMPLE - Change the example grammar rules below ***/

function : FN IDENTIFIER LPAREN RPAREN LBRACE RBRACE

globaldecl : function

globaldecls : globaldecl 
            | globaldecl globaldecls

module	: /* empty */ END
        | globaldecls 

 /*** END EXAMPLE - Change the example grammar rules above ***/

%% /*** Additional Code ***/

void magma::yacc::Parser::error(const Parser::location_type &l,
                                const std::string &m) {
  driver.error(l, m);
}

int magma::parse::parser::parse(const char* path) {
  std::fstream in{path};

  example::Scanner scanner{&in};
  scanner.set_debug(true);

  this->lexer = &scanner;
  magma::yacc::Parser parser{*this};

  parser.parse();
  return 0;
}

