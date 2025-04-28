include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")
set(getting_started_sam_e51_cnano_sam_e51_cnano_library_list )
# Handle files with suffix s 
if(getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_assemble)
    add_library(getting_started_sam_e51_cnano_sam_e51_cnano_assemble OBJECT ${getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_assemble})
    getting_started_sam_e51_cnano_sam_e51_cnano_assemble_rule(getting_started_sam_e51_cnano_sam_e51_cnano_assemble)
    list(APPEND getting_started_sam_e51_cnano_sam_e51_cnano_library_list "$<TARGET_OBJECTS:getting_started_sam_e51_cnano_sam_e51_cnano_assemble>")
endif()

# Handle files with suffix S 
if(getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_assembleWithPreprocess)
    add_library(getting_started_sam_e51_cnano_sam_e51_cnano_assembleWithPreprocess OBJECT ${getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_assembleWithPreprocess})
    getting_started_sam_e51_cnano_sam_e51_cnano_assembleWithPreprocess_rule(getting_started_sam_e51_cnano_sam_e51_cnano_assembleWithPreprocess)
    list(APPEND getting_started_sam_e51_cnano_sam_e51_cnano_library_list "$<TARGET_OBJECTS:getting_started_sam_e51_cnano_sam_e51_cnano_assembleWithPreprocess>")
endif()

# Handle files with suffix [cC] 
if(getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_compile)
    add_library(getting_started_sam_e51_cnano_sam_e51_cnano_compile OBJECT ${getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_compile})
    getting_started_sam_e51_cnano_sam_e51_cnano_compile_rule(getting_started_sam_e51_cnano_sam_e51_cnano_compile)
    list(APPEND getting_started_sam_e51_cnano_sam_e51_cnano_library_list "$<TARGET_OBJECTS:getting_started_sam_e51_cnano_sam_e51_cnano_compile>")
endif()

# Handle files with suffix cpp 
if(getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_compile_cpp)
    add_library(getting_started_sam_e51_cnano_sam_e51_cnano_compile_cpp OBJECT ${getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_compile_cpp})
    getting_started_sam_e51_cnano_sam_e51_cnano_compile_cpp_rule(getting_started_sam_e51_cnano_sam_e51_cnano_compile_cpp)
    list(APPEND getting_started_sam_e51_cnano_sam_e51_cnano_library_list "$<TARGET_OBJECTS:getting_started_sam_e51_cnano_sam_e51_cnano_compile_cpp>")
endif()

if (BUILD_LIBRARY)
        message(STATUS "Building LIBRARY")
        add_library(${getting_started_sam_e51_cnano_sam_e51_cnano_image_name} ${getting_started_sam_e51_cnano_sam_e51_cnano_library_list})
        foreach(lib ${getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_link})
        target_link_libraries(${getting_started_sam_e51_cnano_sam_e51_cnano_image_name} PRIVATE ${CMAKE_CURRENT_LIST_DIR} /${lib})
        endforeach()
        add_custom_command(
            TARGET ${getting_started_sam_e51_cnano_sam_e51_cnano_image_name}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${getting_started_sam_e51_cnano_sam_e51_cnano_output_dir}
    COMMAND ${CMAKE_COMMAND} -E copy lib${getting_started_sam_e51_cnano_sam_e51_cnano_image_name}.a ${getting_started_sam_e51_cnano_sam_e51_cnano_output_dir}/${getting_started_sam_e51_cnano_sam_e51_cnano_original_image_name})
else()
    message(STATUS "Building STANDARD")
    add_executable(${getting_started_sam_e51_cnano_sam_e51_cnano_image_name} ${getting_started_sam_e51_cnano_sam_e51_cnano_library_list})
    foreach(lib ${getting_started_sam_e51_cnano_sam_e51_cnano_FILE_GROUP_link})
    target_link_libraries(${getting_started_sam_e51_cnano_sam_e51_cnano_image_name} PRIVATE ${CMAKE_CURRENT_LIST_DIR}/${lib})
endforeach()
    getting_started_sam_e51_cnano_sam_e51_cnano_link_rule(${getting_started_sam_e51_cnano_sam_e51_cnano_image_name})
        add_custom_target(
        getting_started_sam_e51_cnano_sam_e51_cnano_Bin2Hex
        ALL
        ${MP_BIN2HEX} ${getting_started_sam_e51_cnano_sam_e51_cnano_image_name}
    )
    add_dependencies(getting_started_sam_e51_cnano_sam_e51_cnano_Bin2Hex ${getting_started_sam_e51_cnano_sam_e51_cnano_image_name})

add_custom_command(
    TARGET ${getting_started_sam_e51_cnano_sam_e51_cnano_image_name}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${getting_started_sam_e51_cnano_sam_e51_cnano_output_dir}
    COMMAND ${CMAKE_COMMAND} -E copy ${getting_started_sam_e51_cnano_sam_e51_cnano_image_name} ${getting_started_sam_e51_cnano_sam_e51_cnano_output_dir}/${getting_started_sam_e51_cnano_sam_e51_cnano_original_image_name})
endif()
