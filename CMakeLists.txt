# CMakeList.txt : CMake project for tinyTcpServer, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.10)

project ("toftof-server")

add_subdirectory(dyad/src)

# Add source to this project's executable.
add_executable (${PROJECT_NAME}  "main.c" )

target_link_libraries(${PROJECT_NAME} dyad)
target_link_options(${PROJECT_NAME}  PRIVATE $<$<CXX_COMPILER_ID:GNU>:-Wl,-rpath,.>  )


if(WIN32)
 install(
    TARGETS ${PROJECT_NAME}
        RUNTIME  DESTINATION $ENV{HOMEDRIVE}$ENV{HOMEPATH} #or use $ENV{USERPROFILE}
  )
 else()
 install(
    TARGETS ${PROJECT_NAME}
        RUNTIME  DESTINATION ~/
		
		
  )
 endif()

