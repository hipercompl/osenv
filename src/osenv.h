#include <stdlib.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT char *get_env(const char *name);
FFI_PLUGIN_EXPORT int set_env(const char *name, const char *value);
FFI_PLUGIN_EXPORT int unset_env(const char *name);
