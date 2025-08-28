#include <ares.h>
#include <moonbit.h>
#include <stdint.h>

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_library_init(int32_t flags) {
  return ares_library_init(flags);
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ARES_LIB_INIT_ALL() {
  return ARES_LIB_INIT_ALL;
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ARES_LIB_INIT_NONE() {
  return ARES_LIB_INIT_NONE;
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_threadsafety() {
  return ares_threadsafety();
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ARES_OPT_EVENT_THREAD() {
  return ARES_OPT_EVENT_THREAD;
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ARES_EVSYS_DEFAULT() {
  return ARES_EVSYS_DEFAULT;
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_init_options(
  ares_channel_t **channelptr,
  const struct ares_options *options,
  int32_t optmask
) {
  return ares_init_options(channelptr, options, optmask);
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ARES_AI_CANONNAME() {
  return ARES_AI_CANONNAME;
}

MOONBIT_FFI_EXPORT
struct ares_options *
moonbit_ares_options_new(ares_evsys_t evsys) {
  struct ares_options *options =
    (struct ares_options *)moonbit_make_bytes(sizeof(struct ares_options), 0);
  options->evsys = evsys;
  return options;
}

typedef struct moonbit_ares_addrinfo_callback {
  int32_t (*callback)(
    struct moonbit_ares_addrinfo_callback *arg,
    int32_t status,
    int32_t timeouts,
    struct ares_addrinfo *result
  );
} moonbit_ares_addrinfo_callback_t;

static inline void
moonbit_ares_addrinfo_callback(
  void *arg,
  int status,
  int timeouts,
  struct ares_addrinfo *result
) {
  moonbit_ares_addrinfo_callback_t *cb = arg;
  cb->callback(cb, status, timeouts, result);
}

MOONBIT_FFI_EXPORT
void
moonbit_ares_getaddrinfo(
  ares_channel_t *channel,
  const char *node,
  const char *service,
  const struct ares_addrinfo_hints *hints,
  moonbit_ares_addrinfo_callback_t *callback
) {
  return ares_getaddrinfo(
    channel, node, service, hints, moonbit_ares_addrinfo_callback, callback
  );
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_addrinfo_cname_ttl(struct ares_addrinfo_cname *cname) {
  return cname->ttl;
}

MOONBIT_FFI_EXPORT
const char *
moonbit_ares_addrinfo_cname_alias(struct ares_addrinfo_cname *cname) {
  return cname->alias;
}

MOONBIT_FFI_EXPORT
const char *
moonbit_ares_addrinfo_cname_name(struct ares_addrinfo_cname *cname) {
  return cname->name;
}

MOONBIT_FFI_EXPORT
struct ares_addrinfo_cname *
moonbit_ares_addrinfo_cname_next(struct ares_addrinfo_cname *cname) {
  return cname->next;
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_addrinfo_node_ttl(struct ares_addrinfo_node *node) {
  return node->ai_ttl;
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_addrinfo_node_flags(struct ares_addrinfo_node *node) {
  return node->ai_flags;
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_addrinfo_node_family(struct ares_addrinfo_node *node) {
  return node->ai_family;
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_addrinfo_node_socktype(struct ares_addrinfo_node *node) {
  return node->ai_socktype;
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_addrinfo_node_protocol(struct ares_addrinfo_node *node) {
  return node->ai_protocol;
}

MOONBIT_FFI_EXPORT
size_t
moonbit_ares_addrinfo_node_addrlen(struct ares_addrinfo_node *node) {
  return node->ai_addrlen;
}

MOONBIT_FFI_EXPORT
struct sockaddr *
moonbit_ares_addrinfo_node_addr(struct ares_addrinfo_node *node) {
  return node->ai_addr;
}

MOONBIT_FFI_EXPORT
struct ares_addrinfo_node *
moonbit_ares_addrinfo_node_next(struct ares_addrinfo_node *node) {
  return node->ai_next;
}
