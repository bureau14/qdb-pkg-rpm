if(CMAKE_BUILD_TYPE STREQUAL Release)
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/quasardb.spec.in" "${CMAKE_CURRENT_SOURCE_DIR}/quasardb.spec" @ONLY NEWLINE_STYLE UNIX)
endif()
