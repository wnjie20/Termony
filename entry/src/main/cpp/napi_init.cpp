#include "napi/native_api.h"
#include <string>
#include <stdio.h>
#include <assert.h>
#include <fcntl.h>
#include <unistd.h>

static FILE *fp = nullptr;
static int fd = -1;

static napi_value Run(napi_env env, napi_callback_info info)
{
    assert(fp == nullptr);
    fp = popen("echo 123 && sleep 5 && echo 123", "r");
    // extract fd
    fd = fileno(fp);
    // set nonblocking
    assert(fcntl(fd, F_SETFL, O_NONBLOCK) == 0);
    return nullptr;
}

static napi_value Read(napi_env env, napi_callback_info info)
{
    char buffer[128];
    ssize_t r = read(fd, buffer, sizeof(buffer)-1);
    if (r > 0) {
        buffer[r] = '\0';
        napi_value ret;
        napi_create_string_utf8(env, buffer, r, &ret);
        return ret;
    } else if (r == -1 && errno == EAGAIN) {
        // empty string
        buffer[0] = '\0';
        napi_value ret;
        napi_create_string_utf8(env, buffer, r, &ret);
        return ret;
    } else {
        return nullptr;
    }
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "run", nullptr, Run, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "read", nullptr, Read, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
