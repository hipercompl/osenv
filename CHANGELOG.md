# Changelog

## 1.0.1
Added extra `nullptr` checks to prevent freeing native memory if it hasn't been successfully allocated (for example when `toNativeUtf8()` failed to allocate a new UTF-8 string in the native memory).

## 1.0.0
Getting, setting and removing environment variables works on Windows, Linux and Android.
