# CMakeList.txt : CMake project for tinyTcpServer, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.10)

project ("toftof-server")
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS YES CACHE BOOL "Export all symbols")
add_library (dyad SHARED "dyad/src/dyad.c")
target_link_libraries(dyad  PRIVATE $<$<CXX_COMPILER_ID:MSVC>:wsock32>  $<$<CXX_COMPILER_ID:MSVC>:ws2_32>)

# Add source to this project's executable.
add_executable (${PROJECT_NAME}  "main.c" )
target_link_libraries(${PROJECT_NAME} PUBLIC dyad)
target_link_options(${PROJECT_NAME}  PRIVATE $<$<CXX_COMPILER_ID:GNU>:-Wl,-rpath,.>  )
target_link_libraries(${PROJECT_NAME}  PRIVATE $<$<CXX_COMPILER_ID:MSVC>:wsock32>  $<$<CXX_COMPILER_ID:MSVC>:ws2_32>)


if(WIN32)
set(install_dir $ENV{HOMEDRIVE}$ENV{HOMEPATH})
else()
set(install_dir ~/)
endif()


install(
    TARGETS ${PROJECT_NAME}
       RUNTIME  DESTINATION ${install_dir}
)
install(
    TARGETS dyad
       RUNTIME  DESTINATION ${install_dir}
       LIBRARY DESTINATION ${install_dir}
)
   
