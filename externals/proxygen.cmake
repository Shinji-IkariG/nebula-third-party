set(name proxygen)
set(source_dir ${CMAKE_CURRENT_BINARY_DIR}/${name}/source)

set(LIBS "-lssl -lcrypto -ldl -lrt -lglog -lunwind")
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    # clang requires explicitly linking to libatomic
    set(LIBS "${LIBS} -latomic")
endif()

ExternalProject_Add(
    ${name}
    URL https://github.com/facebook/proxygen/archive/v2018.08.20.00.tar.gz
    URL_HASH MD5=cc71ffdf502355b05451bcd81478f3d7
    DOWNLOAD_NAME proxygen-2018-08-20.tar.gz
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${name}
    TMP_DIR ${BUILD_INFO_DIR}
    STAMP_DIR ${BUILD_INFO_DIR}
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
    SOURCE_DIR ${source_dir}
    PATCH_COMMAND patch -p0 < ${CMAKE_SOURCE_DIR}/patches/proxygen-2018-08-20.patch
    CONFIGURE_COMMAND ""
    BUILD_COMMAND env PATH=${BUILDING_PATH} make -s -j${BUILDING_JOBS_NUM} -C proxygen
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND env PATH=${BUILDING_PATH} make -s -j${BUILDING_JOBS_NUM} install -C proxygen
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_MERGED_STDOUTERR TRUE
)

ExternalProject_Add_Step(proxygen mannual-configure
    DEPENDEES download update patch configure
    DEPENDERS build install
    COMMAND env PATH=${BUILDING_PATH} ACLOCAL_PATH=${ACLOCAL_PATH} autoreconf -if
    COMMAND
        ${common_configure_envs}
        "LIBS=${LIBS}"
        ./configure
            ${common_configure_args}
            --disable-shared
            --enable-static
    WORKING_DIRECTORY ${source_dir}/proxygen
)

ExternalProject_Add_Step(${name} clean
    EXCLUDE_FROM_MAIN TRUE
    ALWAYS TRUE
    DEPENDEES mannual-configure
    COMMAND make clean -j
    COMMAND rm -f ${BUILD_INFO_DIR}/${name}-build
    WORKING_DIRECTORY ${source_dir}/proxygen
)

ExternalProject_Add_StepTargets(${name} clean)
