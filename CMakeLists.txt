cmake_minimum_required(VERSION 3.10)

project(UnixThreads VERSION 1.0
                    DESCRIPTION "Simple implementation of Unix Threads in C++"
                    LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

add_executable(${PROJECT_NAME} main.cpp)

target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(${PROJECT_NAME} PRIVATE pthread)