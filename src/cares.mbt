///|
pub const LIB_INIT_NONE : Int = 0

///|
pub const LIB_INIT_WIN32 : Int = 1 << 0

///|
pub const LIB_INIT_ALL : Int = LIB_INIT_WIN32

///|
extern "c" fn ares_library_init(flags : Int) -> Int = "ares_library_init"

///|
pub fn library_init(flags : Int) -> Unit raise E {
  let status = ares_library_init(flags)
  if status != 0 {
    raise E::of_int(status)
  }
}

///|
pub extern "c" fn library_cleanup() = "ares_library_cleanup"

///|
pub extern "c" fn threadsafety() -> Bool = "moonbit_ares_threadsafety"

///|
pub const AI_CANONNAME : Int = 1 << 0

///|
pub const AI_NUMERICHOST : Int = 1 << 1

///|
pub const AI_PASSIVE : Int = 1 << 2

///|
pub const AI_NUMERICSERV : Int = 1 << 3

///|
pub const AI_V4MAPPED : Int = 1 << 4

///|
pub const AI_ALL : Int = 1 << 5

///|
pub const AI_ADDRCONFIG : Int = 1 << 6

///|
pub const AI_NOSORT : Int = 1 << 7

///|
pub const AI_ENVHOSTS : Int = 1 << 8

///|
pub const OPT_FLAGS : Int = 1 << 0

///|
pub const OPT_TIMEOUT : Int = 1 << 1

///|
pub const OPT_TRIES : Int = 1 << 2

///|
pub const OPT_NDOTS : Int = 1 << 3

///|
pub const OPT_UDP_PORT : Int = 1 << 4

///|
pub const OPT_TCP_PORT : Int = 1 << 5

///|
pub const OPT_SERVERS : Int = 1 << 6

///|
pub const OPT_DOMAINS : Int = 1 << 7

///|
pub const OPT_LOOKUPS : Int = 1 << 8

///|
pub const OPT_SOCK_STATE_CB : Int = 1 << 9

///|
pub const OPT_SORTLIST : Int = 1 << 10

///|
pub const OPT_SOCK_SNDBUF : Int = 1 << 11

///|
pub const OPT_SOCK_RCVBUF : Int = 1 << 12

///|
pub const OPT_TIMEOUTMS : Int = 1 << 13

///|
pub const OPT_ROTATE : Int = 1 << 14

///|
pub const OPT_EDNSPSZ : Int = 1 << 15

///|
pub const OPT_NOROTATE : Int = 1 << 16

///|
pub const OPT_RESOLVCONF : Int = 1 << 17

///|
pub const OPT_HOSTS_FILE : Int = 1 << 18

///|
pub const OPT_UDP_MAX_QUERIES : Int = 1 << 19

///|
pub const OPT_MAXTIMEOUTMS : Int = 1 << 20

///|
pub const OPT_QUERY_CACHE : Int = 1 << 21

///|
pub const OPT_EVENT_THREAD : Int = 1 << 22

///|
pub const OPT_SERVER_FAILOVER : Int = 1 << 23

///|
struct AddrInfoHints(FixedArray[Int])

///|
pub fn AddrInfoHints::new(
  flags? : Int = 0,
  family? : AF = UNSPEC,
  socktype? : Int = 0,
  protocol? : Int = 0,
) -> AddrInfoHints {
  AddrInfoHints([flags, family.to_int(), socktype, protocol])
}

///|
struct Options(Bytes)

///|
pub(all) enum Evsys {
  Default = 0
  Win32 = 1
  Epoll = 2
  Kqueue = 3
  Poll = 4
  Select = 5
}

///|
pub extern "c" fn Options::new(evsys~ : Evsys) -> Options = "moonbit_ares_options_new"

///|
#external
type Channel

///|
pub extern "c" fn Channel::null() -> Channel = "moonbit_c_null"

///|
pub extern "c" fn Channel::is_null(self : Channel) -> Bool = "moonbit_c_is_null"

///|
#external
type AddrInfo

///|
pub extern "c" fn AddrInfo::null() -> AddrInfo = "moonbit_c_null"

///|
pub extern "c" fn AddrInfo::is_null(info : AddrInfo) -> Bool = "moonbit_c_is_null"

///|
pub extern "c" fn AddrInfo::free(info : AddrInfo) = "ares_freeaddrinfo"

///|
pub extern "c" fn AddrInfo::nodes(info : AddrInfo) -> AddrInfoNode = "moonbit_ares_addrinfo_nodes"

///|
pub extern "c" fn AddrInfo::cnames(info : AddrInfo) -> AddrInfoCname = "moonbit_ares_addrinfo_cnames"

///|
#external
type AddrInfoCname

///|
pub extern "c" fn AddrInfoCname::null() -> AddrInfoCname = "moonbit_c_null"

///|
pub extern "c" fn AddrInfoCname::is_null(cname : AddrInfoCname) -> Bool = "moonbit_c_is_null"

///|
pub extern "c" fn AddrInfoCname::ttl(cname : AddrInfoCname) -> Int = "moonbit_ares_addrinfo_cname_ttl"

///|
pub extern "c" fn AddrInfoCname::alias_(
  cname : AddrInfoCname,
) -> @c.Pointer[Byte] = "moonbit_ares_addrinfo_cname_alias"

///|
pub extern "c" fn AddrInfoCname::name(
  cname : AddrInfoCname,
) -> @c.Pointer[Byte] = "moonbit_ares_addrinfo_cname_name"

///|
pub extern "c" fn AddrInfoCname::next(cname : AddrInfoCname) -> AddrInfoCname = "moonbit_ares_addrinfo_cname_next"

///|
#external
type AddrInfoNode

///|
pub extern "c" fn AddrInfoNode::null() -> AddrInfoNode = "moonbit_c_null"

///|
pub extern "c" fn AddrInfoNode::is_null(node : AddrInfoNode) -> Bool = "moonbit_c_is_null"

///|
pub extern "c" fn AddrInfoNode::ttl(node : AddrInfoNode) -> Int = "moonbit_ares_addrinfo_node_ttl"

///|
extern "c" fn ares_addrinfo_node_family(node : AddrInfoNode) -> Int = "moonbit_ares_addrinfo_node_family"

///|
pub fn AddrInfoNode::family(node : AddrInfoNode) -> AF {
  AF::of_int(ares_addrinfo_node_family(node))
}

///|
pub extern "c" fn AddrInfoNode::socktype(node : AddrInfoNode) -> Int = "moonbit_ares_addrinfo_node_socktype"

///|
pub extern "c" fn AddrInfoNode::protocol(node : AddrInfoNode) -> Int = "moonbit_ares_addrinfo_node_protocol"

///|
pub extern "c" fn AddrInfoNode::addrlen(node : AddrInfoNode) -> Int = "moonbit_ares_addrinfo_node_addrlen"

///|
pub extern "c" fn AddrInfoNode::addr(node : AddrInfoNode) -> Sockaddr = "moonbit_ares_addrinfo_node_addr"

///|
pub extern "c" fn AddrInfoNode::next(node : AddrInfoNode) -> AddrInfoNode = "moonbit_ares_addrinfo_node_next"

///|
#borrow(channel, node, service, hints, callback)
pub extern "c" fn Channel::getaddrinfo(
  channel : Channel,
  node : Bytes,
  service : Bytes,
  hints : AddrInfoHints,
  callback : (Int, Int, AddrInfo) -> Unit,
) = "moonbit_ares_getaddrinfo"

///|
#borrow(channel, options)
extern "c" fn ares_init_options(
  channel : Ref[Channel],
  options : Options,
  optmask : Int,
) -> Int = "moonbit_ares_init_options"

///|
pub suberror E {
  NODATA
  FORMERR
  SERVFAIL
  NOTFOUND
  NOTIMP
  REFUSED
  BADQUERY
  BADNAME
  BADFAMILY
  BADRESP
  CONNREFUSED
  TIMEOUT
  EOF
  FILE
  NOMEM
  DESTRUCTION
  BADSTR
  BADFLAGS
  NONAME
  BADHINTS
  NOTINITIALIZED
  LOADIPHLPAPI
  ADDRGETNETWORKPARAMS
  CANCELLED
  SERVICE
  NOSERVER
  Unknown(Int)
}

///|
fn E::of_int(status : Int) -> E {
  match status {
    1 => E::NODATA
    2 => E::FORMERR
    3 => E::SERVFAIL
    4 => E::NOTFOUND
    5 => E::NOTIMP
    6 => E::REFUSED
    7 => E::BADQUERY
    8 => E::BADNAME
    9 => E::BADFAMILY
    10 => E::BADRESP
    11 => E::CONNREFUSED
    12 => E::TIMEOUT
    13 => E::EOF
    14 => E::FILE
    15 => E::NOMEM
    16 => E::DESTRUCTION
    17 => E::BADSTR
    18 => E::BADFLAGS
    19 => E::NONAME
    20 => E::BADHINTS
    21 => E::NOTINITIALIZED
    22 => E::LOADIPHLPAPI
    23 => E::ADDRGETNETWORKPARAMS
    24 => E::CANCELLED
    25 => E::SERVICE
    26 => E::NOSERVER
    status => E::Unknown(status)
  }
}

///|
pub fn Channel::new(options : Options, optmask : Int) -> Channel raise E {
  let channel = Ref::new(Channel::null())
  let status = ares_init_options(channel, options, optmask)
  if status == 0 {
    channel.val
  } else {
    raise E::of_int(status)
  }
}

///|
pub extern "c" fn Channel::destroy(self : Channel) = "ares_channel_destroy"

///|
pub(all) enum AF {
  UNSPEC = 0
  INET = 1
  INET6 = 2
}

///|
extern "c" fn AF::to_int(self : AF) -> Int = "moonbit_ares_AF_to_int"

///|
extern "c" fn AF::of_int(value : Int) -> AF = "moonbit_ares_AF_of_int"

///|
extern "c" fn ares_queue_wait_empty(channel : Channel, timeout_ms : Int) -> Int = "ares_queue_wait_empty"

///|
pub fn queue_wait_empty(channel : Channel, timeout_ms : Int) -> Unit raise E {
  let status = ares_queue_wait_empty(channel, timeout_ms)
  if status != 0 {
    raise E::of_int(status)
  }
}

///|
#external
pub type Sockaddr

///|
pub fn Sockaddr::to_sockaddr_in(self : Sockaddr) -> SockaddrIn = "%identity"

///|
pub fn Sockaddr::to_sockaddr_in6(self : Sockaddr) -> SockaddrIn6 = "%identity"

///|
#external
pub type SockaddrIn

///|
pub fn SockaddrIn::to_sockaddr(self : SockaddrIn) -> Sockaddr = "%identity"

///|
#external
pub type SockaddrIn6

///|
pub fn SockaddrIn6::to_sockaddr(self : SockaddrIn6) -> Sockaddr = "%identity"

///|
#external
pub type InAddr

///|
pub extern "c" fn SockaddrIn::addr(self : SockaddrIn) -> InAddr = "moonbit_ares_sockaddr_in_addr"

///|
pub extern "c" fn SockaddrIn::port(self : SockaddrIn) -> UInt16 = "moonbit_ares_sockaddr_in_port"

///|
#external
pub type In6Addr

///|
pub extern "c" fn SockaddrIn6::addr(self : SockaddrIn6) -> In6Addr = "moonbit_ares_sockaddr_in6_addr"

///|
pub extern "c" fn SockaddrIn6::port(self : SockaddrIn6) -> UInt16 = "moonbit_ares_sockaddr_in6_port"

///|
#borrow(buf)
extern "c" fn ares_in_addr_ntop(
  af : Int,
  src : InAddr,
  buf : FixedArray[Byte],
  len : Int,
) = "ares_inet_ntop"

///|
pub const INET_ADDRSTRLEN = 16

///|
pub const INET6_ADDRSTRLEN = 46

///|
pub fn InAddr::ntop(src : InAddr, buf : FixedArray[Byte], len : Int) -> Unit {
  ares_in_addr_ntop(AF::INET.to_int(), src, buf, len)
}

///|
#borrow(buf)
extern "c" fn ares_in6_addr_ntop(
  af : AF,
  src : In6Addr,
  buf : FixedArray[Byte],
  len : Int,
) = "ares_inet_ntop"

///|
pub fn In6Addr::ntop(src : In6Addr, buf : FixedArray[Byte], len : Int) -> Unit {
  ares_in6_addr_ntop(AF::INET6, src, buf, len)
}
