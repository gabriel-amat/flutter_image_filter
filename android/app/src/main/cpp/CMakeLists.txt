cmake_minimum_required(VERSION 3.4.1)

add_library(
        native_filter
        SHARED
        native_filter.c
)

find_library(
        log-lib
        log
)

target_link_libraries(
        native_filter
        ${log-lib}
)
