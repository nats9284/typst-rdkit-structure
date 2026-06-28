#include "emscripten.h"

#include <cffiwrapper.h>
#ifdef __cplusplus
#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#define PROTOCOL_FUNCTION __attribute__((import_module("typst_env"))) extern "C"
#else
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#define PROTOCOL_FUNCTION __attribute__((import_module("typst_env"))) extern
#endif
#define ERROR(str) write_error_message(str)

PROTOCOL_FUNCTION void wasm_minimal_protocol_send_result_to_host(const uint8_t *ptr, size_t len);
PROTOCOL_FUNCTION void wasm_minimal_protocol_write_args_to_buffer(uint8_t *ptr);

void write_error_message(char *message) {
    wasm_minimal_protocol_send_result_to_host((uint8_t *)message, strlen(message));
}

EMSCRIPTEN_KEEPALIVE
int32_t render_molecule(size_t arg1_len, size_t arg2_len) {
    size_t total_len=arg1_len+arg2_len;
    uint8_t *args = malloc(total_len);
    //initialize total_len
    if (!args) {
        return 1;
    }
    //initialize total_len
    wasm_minimal_protocol_write_args_to_buffer(args);
    char molstring[arg1_len+1];
    memcpy(molstring, args, arg1_len);
    molstring[arg1_len] = '\0';
    char svginfo[arg2_len+1];
    memcpy(svginfo, args+arg1_len, arg2_len);
    svginfo[arg2_len] = '\0';
    size_t pkl_size;
    char *pkl;
    pkl = get_mol(molstring, &pkl_size, "");
    if (!pkl) {
        ERROR("failed to parse formula");
        return 1;
    }else if (!pkl_size) {
        ERROR("failed to parse formula");
        free(pkl);
        return 1;
    }
    char *svg = get_svg(pkl, pkl_size, (char *)svginfo );
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
    
    size_t svgLength=strlen(svg);
    
    wasm_minimal_protocol_send_result_to_host((uint8_t *)svg, svgLength);
    
    free(pkl);
    free(svg);
    return 0;
}

EMSCRIPTEN_KEEPALIVE
int32_t render_reaction(size_t arg1_len, size_t arg2_len) {
    uint8_t *args = malloc(arg1_len);
    if (!args) {
        return 1;
    }
    wasm_minimal_protocol_write_args_to_buffer(args);
    char rxnstring[arg1_len+1];
    memcpy(rxnstring, args, arg1_len);
    rxnstring[arg1_len] = '\0';
    char svginfo[arg2_len+1];
    memcpy(svginfo, args+arg1_len, arg2_len);
    svginfo[arg2_len] = '\0';
    size_t pkl_size;
    char *pkl;
    pkl = get_rxn((char*)rxnstring, &pkl_size, "");
    if (!pkl) {
        ERROR("failed to parse string");
        return 1;
    }else if (!pkl_size) {
        ERROR("failed to get rxn object");
        free(pkl);
        return 1;
    }
    char *svg = get_rxn_svg(pkl, pkl_size, (char *)svginfo );
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

    size_t svgLength=strlen(svg);


    wasm_minimal_protocol_send_result_to_host((uint8_t *)svg, svgLength);

    free(pkl);
    free(svg);
    return 0;
}
