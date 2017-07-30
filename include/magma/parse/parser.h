#ifndef MAGMA_PARSE_PARSER_H
#define MAGMA_PARSE_PARSER_H

#include <string>
#include <iostream>

namespace magma {
namespace parse {

class parser {
public:
  int parse(const char *path);
  std::string path_;
  const bool trace_scanning = true;

  template<typename T, typename U>
  void error(const T &t, const U &u){
    std::cerr << t << u << "\n"; 
  }

  void scan_begin();
  void scan_end();

  void *lexer;
};

} // End of namespace parse
} // End of namespace magma 

#endif // MAGMA_PARSE_PARSER_H

