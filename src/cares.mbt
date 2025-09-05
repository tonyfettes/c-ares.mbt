///|
pub const LIB_INIT_NONE : Int = 0

///|
pub const LIB_INIT_WIN32 : Int = 1 << 0

///|
pub const LIB_INIT_ALL : Int = LIB_INIT_WIN32

///|
extern "c" fn ares_library_init(flags : Int) -> Int = "ares_library_init"

///|
pub fn library_init(flags : Int) -> Unit raise Errno {
  let status = ares_library_init(flags)
  if status != 0 {
    raise Errno::of_int(status)
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
  family? : Int = 0,
  socktype? : Int = 0,
  protocol? : Int = 0,
) -> AddrInfoHints {
  AddrInfoHints([flags, family, socktype, protocol])
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
pub extern "c" fn AddrInfoNode::family(node : AddrInfoNode) -> Int = "moonbit_ares_addrinfo_node_family"

///|
pub extern "c" fn AddrInfoNode::socktype(node : AddrInfoNode) -> @socket.Type = "moonbit_ares_addrinfo_node_socktype"

///|
pub extern "c" fn AddrInfoNode::protocol(node : AddrInfoNode) -> Int = "moonbit_ares_addrinfo_node_protocol"

///|
pub extern "c" fn AddrInfoNode::addr(node : AddrInfoNode) -> @socket.Sockaddr = "moonbit_ares_addrinfo_node_addr"

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
pub suberror Errno {
  ENODATA
  EFORMERR
  ESERVFAIL
  ENOTFOUND
  ENOTIMP
  EREFUSED
  EBADQUERY
  EBADNAME
  EBADFAMILY
  EBADRESP
  ECONNREFUSED
  ETIMEOUT
  EOF
  EFILE
  ENOMEM
  EDESTRUCTION
  EBADSTR
  EBADFLAGS
  ENONAME
  EBADHINTS
  ENOTINITIALIZED
  ELOADIPHLPAPI
  EADDRGETNETWORKPARAMS
  ECANCELLED
  ESERVICE
  ENOSERVER
  UNKNOWN(Int)
}

///|
fn Errno::of_int(status : Int) -> Errno {
  match status {
    1 => Errno::ENODATA
    2 => Errno::EFORMERR
    3 => Errno::ESERVFAIL
    4 => Errno::ENOTFOUND
    5 => Errno::ENOTIMP
    6 => Errno::EREFUSED
    7 => Errno::EBADQUERY
    8 => Errno::EBADNAME
    9 => Errno::EBADFAMILY
    10 => Errno::EBADRESP
    11 => Errno::ECONNREFUSED
    12 => Errno::ETIMEOUT
    13 => Errno::EOF
    14 => Errno::EFILE
    15 => Errno::ENOMEM
    16 => Errno::EDESTRUCTION
    17 => Errno::EBADSTR
    18 => Errno::EBADFLAGS
    19 => Errno::ENONAME
    20 => Errno::EBADHINTS
    21 => Errno::ENOTINITIALIZED
    22 => Errno::ELOADIPHLPAPI
    23 => Errno::EADDRGETNETWORKPARAMS
    24 => Errno::ECANCELLED
    25 => Errno::ESERVICE
    26 => Errno::ENOSERVER
    status => Errno::UNKNOWN(status)
  }
}

///|
pub fn Channel::new(options : Options, optmask : Int) -> Channel raise Errno {
  let channel = Ref::new(Channel::null())
  let status = ares_init_options(channel, options, optmask)
  if status == 0 {
    channel.val
  } else {
    raise Errno::of_int(status)
  }
}

///|
pub extern "c" fn Channel::destroy(self : Channel) = "ares_channel_destroy"

///|
extern "c" fn ares_queue_wait_empty(channel : Channel, timeout_ms : Int) -> Int = "ares_queue_wait_empty"

///|
pub fn queue_wait_empty(
  channel : Channel,
  timeout_ms : Int,
) -> Unit raise Errno {
  let status = ares_queue_wait_empty(channel, timeout_ms)
  if status != 0 {
    raise Errno::of_int(status)
  }
}
