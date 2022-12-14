cmake_minimum_required(VERSION 3.0.0)
project(canciones VERSION 0.1.0)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED true)

find_program(LEX_EXE
    flex
)
if(LEX_EXE STREQUAL "LEX_EXE-NOTFOUND")
    message(FATAL_ERROR "flex executable not found")
endif(LEX_EXE STREQUAL "LEX_EXE-NOTFOUND")

# lex source file macro
MACRO(LEX_FILE _filename)
    GET_FILENAME_COMPONENT(_basename ${_filename} NAME_WE)
    ADD_CUSTOM_COMMAND(
        OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.c
        COMMAND ${LEX_EXE}
                -o${_basename}.c
                ${CMAKE_CURRENT_SOURCE_DIR}/${_filename}
        DEPENDS ${_filename} )
ENDMACRO(LEX_FILE)

LEX_FILE(src/words.lex)
SET_SOURCE_FILES_PROPERTIES(${CMAKE_CURRENT_BINARY_DIR}/words.c GENERATED)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
add_compile_definitions(__STDC_WANT_LIB_EXT2__=1)

add_executable(canciones words.c src/word_list.c)
