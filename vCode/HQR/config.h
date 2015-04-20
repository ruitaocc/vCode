

#define MAJOR_VERSION 3
#define MINOR_VERSION 3
#define MICRO_VERSION 1
#define VERSION "3.3.1"

#define __STATIC static

#if defined(_WIN32) || defined(_WIN64)
  #define snprintf _snprintf
  #define vsnprintf _vsnprintf
  #define strcasecmp _stricmp
  #define strncasecmp _strnicmp
#endif