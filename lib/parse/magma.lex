/* $Id$ -*- mode: c++ -*- */
/** \file scanner.ll Define the example Flex lexical scanner */

%{ /*** C/C++ Declarations ***/

#include <string>

#include <magma/parse/parser.h>
#include "scanner.h"

/* import the parser's token type into a local typedef */
typedef magma::yacc::Parser::token token;
typedef magma::yacc::Parser::token_type token_type;

/* By default yylex returns int, we use token_type. Unfortunately yyterminate
 * by default returns 0, which is not of token_type. */
#define yyterminate() return token::END

/* This disables inclusion of unistd.h, which is not available under Visual C++
 * on Win32. The C++ scanner uses STL streams instead. */
#define YY_NO_UNISTD_H

%}

/*** Flex Declarations and Options ***/

/* enable c++ scanner class generation */
%option c++

/* change the name of the scanner class. results in "ExampleFlexLexer" */
%option prefix="Example"

/* the manual says "somewhat more optimized" */
%option batch

/* enable scanner to generate debug output. disable this for release
 * versions. */
%option debug

/* no support for include files is planned */
%option yywrap nounput 

/* enables the use of start condition stacks */
%option stack

/* The following paragraph suffices to track locations accurately. Each time
 * yylex is invoked, the begin position is moved onto the end position. */
%{
#define YY_USER_ACTION  yylloc->columns(yyleng);
%}

/**
 * Define patterns. 
 */
identifier	[[:alpha:]][[:alnum:]]* 
lit_int		[1-9][0-9]*
lit_float	[0-9]+"."[0-9]*
lparen		"("
rparen		")"
lbrace 		"{"
rbrace 		"}"
sep_term 	";"

%% /*** Regular Expressions Part ***/

 /* code to place at the beginning of yylex() */
%{
  // reset location
  yylloc->step();
%}

 /*** BEGIN EXAMPLE - Change the example lexer rules below ***/

fn {
  return token::kw_fn;
}

uniform {
  return token::kw_uniform;
}

vector {
  return token::kw_vector;
}

":" {
  return token::sep_colon;
}

"=" {
  return token::op_assign;
}

"+" {
  return token::op_add;
}

"-" {
  return token::op_sub;
}

{lparen} {
  std::cerr << "Tok: (" << std::endl;
  return token::lparen;
}

{rparen} {
  std::cerr << "Tok: (" << std::endl;
  return token::rparen;
}

{lbrace} { return token::LBRACE; }
{rbrace} { return token::RBRACE; }
{sep_term} { return token::sep_term; }

{identifier} {
  return token::identifier;
}

{lit_int} {
  yylval->integerVal = atoi(yytext);
  return token::lit_int;
}

{lit_float} {
  yylval->doubleVal = atof(yytext);
  return token::lit_float;
}

 /* gobble up white-spaces */
[ \t\r]+ {
  yylloc->step();
}

 /* gobble up end-of-lines */
\n {
  yylloc->lines(yyleng); yylloc->step();
}

 /* pass all other characters up to bison */
 /* . {
  std::cerr << "Unhandled token: " << std::string(yytext, yyleng)
            << std::endl;
  //std::terminate(-1);
  return static_cast<token_type>(*yytext);
}
*/

 /*** END EXAMPLE - Change the example lexer rules above ***/

%% /*** Additional Code ***/

namespace example {

Scanner::Scanner(std::istream* in, std::ostream* out)
  : ExampleFlexLexer(in, out) {
}

Scanner::~Scanner() { }

void Scanner::set_debug(bool b) {
    yy_flex_debug = b;
}

}

/* This implementation of ExampleFlexLexer::yylex() is required to fill the
 * vtable of the class ExampleFlexLexer. We define the scanner's main yylex
 * function via YY_DECL to reside in the Scanner class instead. */

#ifdef yylex
#undef yylex
#endif

int ExampleFlexLexer::yylex()
{
    std::cerr << "in ExampleFlexLexer::yylex() !" << std::endl;
    return 0;
}

/* When the scanner receives an end-of-file indication from YY_INPUT, it then
 * checks the yywrap() function. If yywrap() returns false (zero), then it is
 * assumed that the function has gone ahead and set up `yyin' to point to
 * another input file, and scanning continues. If it returns true (non-zero),
 * then the scanner terminates, returning 0 to its caller. */

int ExampleFlexLexer::yywrap() {
    return 1;
}
