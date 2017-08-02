/* $Id$ -*- mode: c++ -*- */
/** \file parser.yy Contains the example Bison parser source */

%{ /*** C/C++ Declarations ***/

#include <fstream>
#include <stdio.h>
#include <string>
#include <vector>

#include "expression.h"

#include <magma/ast/translation_unit.h>
#include <magma/parse/parser.h>

using translation_unit_ptr = std::unique_ptr<magma::ast::translation_unit>;
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

/* Use C++ variant support, enabling nodes to use raw C++ types. */
%define api.value.type variant

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

%token			END	     0	"end of file"
%token			sep_colon	":"
%token			sep_term	";"
%token			sep_comma	","

%token			identifier	"identifier"

%token			kw_uniform	"uniform"
%token			kw_vector	"vector"
%token			kw_fn		"fn"
%token			kw_vs		"vs"
%token			kw_hs		"hs"
%token			kw_ds		"ds"
%token			kw_gs		"gs"
%token			kw_fs		"fs"
%token			kw_cs		"cs"

%token			op_assign	"="
%token			op_add		"+"
%token			op_sub		"-"
%token			op_mul		"*"
%token			op_div		"/"

%token			lit_int		"int-literal"
%token			lit_float	"fp-literal"

%token                  lparen		"("
%token			rparen		")"
%token			LBRACE		"{"
%token			RBRACE		"}"
%token  	INTEGER		"integer"
%token  	DOUBLE		"double"
%token  	STRING		"string"


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

literal: lit_int
       | lit_float

variable: identifier
	| literal

expr: variable
    | binary_expr
    | call_expr

binary_op: op_add
         | op_sub
         | op_mul
         | op_div

binary_expr: expr binary_op expr

expr_list: expr
         | expr sep_comma expr_list

call_expr: identifier lparen rparen
         | identifier lparen expr_list rparen

kw_decl: kw_uniform
       | kw_vector

vardecl : kw_decl identifier sep_colon identifier op_assign expr 

statement : sep_term 
          | vardecl sep_term

statement_list : /* empty */
               | statement statement_list

function : kw_fn identifier lparen rparen LBRACE statement_list RBRACE

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

