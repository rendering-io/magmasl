#include <magma/parse/parser.h>

int main(int argc, char **argv) {
  magma::parse::parser parser;

  const char *path = argc > 1 ? argv[1] : "-";
  return parser.parse(path);
}

