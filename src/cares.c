#include <ares.h>
#include <moonbit.h>
#include <stdint.h>

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_threadsafety() {
  return ares_threadsafety();
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

MOONBIT_FFI_EXPORT
struct ares_addrinfo_node *
moonbit_ares_addrinfo_nodes(struct ares_addrinfo *ai) {
  return ai->nodes;
}

MOONBIT_FFI_EXPORT
struct ares_addrinfo_cname *
moonbit_ares_addrinfo_cnames(struct ares_addrinfo *ai) {
  return ai->cnames;
}

typedef enum moonbit_ares_af {
  MOONBIT_ARES_AF_UNSPEC = 0,
  MOONBIT_ARES_AF_INET = 1,
  MOONBIT_ARES_AF_INET6 = 2,
} moonbit_ares_af_t;

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_AF_to_int(moonbit_ares_af_t af) {
  switch (af) {
  case MOONBIT_ARES_AF_UNSPEC:
    return AF_UNSPEC;
  case MOONBIT_ARES_AF_INET:
    return AF_INET;
  case MOONBIT_ARES_AF_INET6:
    return AF_INET6;
  }
}

MOONBIT_FFI_EXPORT
int32_t
moonbit_ares_AF_of_int(int32_t af) {
  if (af == AF_INET) {
    return MOONBIT_ARES_AF_INET;
  } else if (af == AF_INET6) {
    return MOONBIT_ARES_AF_INET6;
  } else {
    return MOONBIT_ARES_AF_UNSPEC;
  }
}

MOONBIT_FFI_EXPORT
struct in_addr
moonbit_ares_sockaddr_in_addr(struct sockaddr_in *addr) {
  return addr->sin_addr;
}

MOONBIT_FFI_EXPORT
uint32_t
moonbit_ares_sockaddr_in_port(struct sockaddr_in *addr) {
  return addr->sin_port;
}

MOONBIT_FFI_EXPORT
struct in6_addr
moonbit_ares_sockaddr_in6_addr(struct sockaddr_in6 *addr) {
  return addr->sin6_addr;
}

MOONBIT_FFI_EXPORT
uint32_t
moonbit_ares_sockaddr_in6_port(struct sockaddr_in6 *addr) {
  return addr->sin6_port;
}

MOONBIT_FFI_EXPORT
void
moonbit_ares_inet_ntop(int32_t af, struct in_addr src, char *buf, int32_t len) {
  ares_inet_ntop(af, &src, buf, len);
}

MOONBIT_FFI_EXPORT
void
moonbit_ares_inet6_ntop(
  int32_t af,
  struct in6_addr src,
  char *buf,
  int32_t len
) {
  ares_inet_ntop(af, &src, buf, len);
}
