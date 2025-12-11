#include "osenv.h"

#if _WIN32
#include <windows.h>
#include <winbase.h>
#ifdef UNICODE
#include <wchar.h>
#include <stringapiset.h>
/* On Windows we use static buffers to translate between Utf8 and Unicode. */
#define W_BUF_SIZE 8192
static wchar_t _wbuf1[W_BUF_SIZE];
static wchar_t _wbuf2[W_BUF_SIZE];
#endif /* UNICODE */
#define A_BUF_SIZE 16384
static char _abuf[A_BUF_SIZE];
#endif /* _WIN32 */

FFI_PLUGIN_EXPORT char *get_env(const char *name)
{
#if _WIN32
#ifdef UNICODE
	MultiByteToWideChar(CP_UTF8, MB_PRECOMPOSED, (LPCCH)name, strlen(name), (LPWSTR)_wbuf1, W_BUF_SIZE);
	DWORD rc = GetEnvironmentVariableW((LPCWSTR)_wbuf1, (LPWSTR)_wbuf2, W_BUF_SIZE);
	if (rc > 0)
	{
		WideCharToMultiByte(CP_UTF8, 0, (LPCWCH)_wbuf2, wcslen(_wbuf2), (LPSTR)_abuf, A_BUF_SIZE, NULL, NULL);
		return _abuf;
	}
	else
	{
		return NULL;
	}
#else  /* UNICODE */
	DWORD rc = GetEnvironmentVariableA((LPCSTR)name, (LPSTR)_abuf, BUF_SIZE);
#endif /* UNICODE */
#else
	return getenv(name);
#endif
}

FFI_PLUGIN_EXPORT int set_env(const char *name, const char *value)
{
#if _WIN32
#ifdef UNICODE
	MultiByteToWideChar(CP_UTF8, MB_PRECOMPOSED, (LPCCH)name, strlen(name), (LPWSTR)_wbuf1, W_BUF_SIZE);
	MultiByteToWideChar(CP_UTF8, MB_PRECOMPOSED, (LPCCH)value, strlen(value), (LPWSTR)_wbuf2, W_BUF_SIZE);
	return SetEnvironmentVariableW((LPCWSTR)_wbuf1, (LPCWSTR)_wbuf2);
#else  /* UNICODE */
	return SetEnvironmentVariableA((LPCSTR)name, (LPCSTR)value);
#endif /* UNICODE */
#else
	return setenv(name, value, 1);
#endif
}

FFI_PLUGIN_EXPORT int unset_env(const char *name)
{
#if _WIN32
#ifdef UNICODE
	MultiByteToWideChar(CP_UTF8, MB_PRECOMPOSED, (LPCCH)name, strlen(name), (LPWSTR)_wbuf1, W_BUF_SIZE);
	return SetEnvironmentVariableW((LPCWSTR)_wbuf1, (LPCWSTR)NULL);
#else  /* UNICODE */
	return SetEnvironmentVariableA((LPCSTR)name, (LPCSTR)NULL);
#endif /* UNICODE */
#else
	return unsetenv(name);
#endif
}
