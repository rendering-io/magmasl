###############################################################################
# tools/magmac/CMakeLists.txt
set(SOURCES magmac.c++)
add_executable(magmac ${SOURCES})
target_link_libraries(magmac PRIVATE parse)

