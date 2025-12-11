/// Access environment variables via native code.
///
/// The *osenv* plugin allows not only to read environment
/// variables (which can be easily done by other means,
/// like `Platform.environment`), but also to **modify** their
/// values and **remove** variables from the process environment.
///
/// All three operations: get, set and unset, are implemented
/// by FFI calls to native OS functions. On Windows, those are
/// `GetEnvironmentVariable` and `SetEnvironmentVariable`, on other
/// systems `getenv`, `setenv` and `unsetenv` are called.
library;

import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'osenv_bindings_generated.dart';

/// Gets the value of a variable from the operating system.
///
/// Retrieves the value of the variable [name]. Returns the value
/// or `null` if the variable is not set.
/// Internally, calls `getenv` (POSIX) or `GetEnvironmentVariable`
/// (Windows).
String? getEnv(String name) {
  final namePtr = name.toNativeUtf8();
  try {
    final varVal = _bindings.get_env(namePtr.cast());
    if (varVal == nullptr) {
      return null;
    }
    return varVal.cast<Utf8>().toDartString();
  } finally {
    malloc.free(namePtr);
  }
}

/// Assigns a new value to a variable.
///
/// Sets the variable [name] to the value [value]. If the variable
/// already existed in the current process' environment, its value
/// is overwritten. If not, a new variable is added.
/// Returns `true` on success, `false` on failure.
bool setEnv(String name, String value) {
  final namePtr = name.toNativeUtf8();
  final valuePtr = value.toNativeUtf8();
  try {
    final res = _bindings.set_env(namePtr.cast(), valuePtr.cast());
    return res == 0;
  } finally {
    malloc.free(namePtr);
    malloc.free(valuePtr);
  }
}

/// Removes a variable from the process' environment.
///
/// Removes the variable [name], together with its associated
/// value, from the environment of the current process.
/// Returns `true` on success, `false` on failure.
bool unsetEnv(String name) {
  final namePtr = name.toNativeUtf8();
  try {
    final res = _bindings.unset_env(namePtr.cast());
    return res == 0;
  } finally {
    malloc.free(namePtr);
  }
}

const String _libName = 'osenv';

final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final OsenvBindings _bindings = OsenvBindings(_dylib);
