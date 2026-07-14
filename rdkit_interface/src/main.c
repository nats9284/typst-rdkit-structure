#include "emscripten.h"

#include <cffiwrapper.h>
#ifdef __cplusplus
#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#define PROTOCOL_FUNCTION __attribute__((import_module("typst_env"))) extern "C"
#define LIFECYCLE_FUNCTION __attribute__((import_module("typst_env"))) extern "C"
#else
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#define PROTOCOL_FUNCTION __attribute__((import_module("typst_env"))) extern
#define LIFECYCLE_FUNCTION __attribute__((import_module("typst_env")))  extern
#endif
#define ERROR(str) write_error_message(str)

PROTOCOL_FUNCTION void wasm_minimal_protocol_send_result_to_host(const uint8_t *ptr, size_t len);
PROTOCOL_FUNCTION void wasm_minimal_protocol_write_args_to_buffer(uint8_t *ptr);
LIFECYCLE_FUNCTION void __wasm_call_ctors(void);

void write_error_message(char *message) {
    wasm_minimal_protocol_send_result_to_host((uint8_t *)message, strlen(message));
}

EMSCRIPTEN_KEEPALIVE
int32_t render_molecule(size_t molStringLen, size_t molOptLen, size_t showOptLen) {
    __wasm_call_ctors();
    size_t totalLen=molStringLen+molOptLen+showOptLen;
    uint8_t *args = malloc(totalLen);
    //initialize totalLen
    if (!args) {
        return 1;
    }
    //initialize totalLen
    wasm_minimal_protocol_write_args_to_buffer(args);
    unsigned char molString[molStringLen+1];
    memcpy(molString, args, molStringLen);
    molString[molStringLen] = '\0';

    unsigned char molOpt[molOptLen+1];
    memcpy(molOpt, args+molStringLen, molOptLen);
    molOpt[molOptLen] = '\0';

    unsigned char showOpt[showOptLen+1];
    memcpy(showOpt, args+molStringLen+molOptLen, showOptLen);
    showOpt[showOptLen] = '\0';

    size_t pkl_size;
    char *pkl;
    pkl = get_mol((char *)molString, &pkl_size, "");
    if (!pkl) {
        ERROR("failed to parse formula");
        return 1;
    }else if (!pkl_size) {
        ERROR("failed to parse formula");
        free(pkl);
        return 1;
    }
    char *svg = get_svg(pkl, pkl_size, (char *)showOpt );
    if (!svg) {
        ERROR("failed to get svg");
        free(pkl);
        return 1;
    }else if (!strstr(svg, "</svg>")) {
        ERROR("failed to get svg");
        free(svg);
        free(pkl);
        return 1;
    }
    
    size_t svgLen=strlen(svg);
    
    wasm_minimal_protocol_send_result_to_host((uint8_t *)svg, svgLen);
    
    free(pkl);
    free(svg);
    return 0;
}

EMSCRIPTEN_KEEPALIVE
int32_t render_reaction(size_t rxnStringLen, size_t rxnOptLen, size_t showOptLen) {
    __wasm_call_ctors();
    size_t totalLen=rxnStringLen+rxnOptLen+showOptLen;
    uint8_t *args = malloc(totalLen);
    if (!args) {
        return 1;
    }
    wasm_minimal_protocol_write_args_to_buffer(args);
    unsigned char rxnString[rxnStringLen+1];
    memcpy(rxnString, args, rxnStringLen);
    rxnString[rxnStringLen] = '\0';

    unsigned char rxnOpt[rxnOptLen+1];
    memcpy(rxnOpt, args+rxnStringLen, rxnOptLen);
    rxnOpt[rxnOptLen] = '\0';

    unsigned char showOpt[showOptLen+1];
    memcpy(showOpt, args+rxnStringLen+rxnOptLen, showOptLen);
    showOpt[showOptLen] = '\0';
    size_t pkl_size;
    char *pkl;
    pkl = get_rxn((char *)rxnString, &pkl_size, (char *)rxnOpt );
    if (!pkl) {
        ERROR("failed to parse string");
        return 1;
    }else if (!pkl_size) {
        ERROR("failed to get rxn object");
        free(pkl);
        return 1;
    }
    char *svg = get_rxn_svg(pkl, pkl_size, (char *)showOpt);
    if (!svg) {
        free(pkl);
        ERROR("failed to get svg");
        return 1;
    }else if (!strstr(svg, "</svg>")) {
        ERROR("failed to get svg");
        free(svg);
        free(pkl);
        return 1;
    }

    size_t svgLen=strlen(svg);


    wasm_minimal_protocol_send_result_to_host((uint8_t *)svg, svgLen);

    free(pkl);
    free(svg);
    return 0;
}

EMSCRIPTEN_KEEPALIVE
int32_t get_version(){
    unsigned char version[6]="0.1.0";
    size_t versionLen=strlen((char *)version);
    wasm_minimal_protocol_send_result_to_host((uint8_t *)version, versionLen);
    return 0;
}
