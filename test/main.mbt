///|
fn main {
  let args = @env.args()
  let node = @encoding.encode(args[1], encoding=UTF8)
  let service = @encoding.encode(args[2], encoding=UTF8)
  @cares.library_init(@cares.LIB_INIT_ALL) catch {
    error => println("Error: \{(error : Error)}")
  }
  defer @cares.library_cleanup()
  if !@cares.threadsafety() {
    println("Warning: c-ares library is not thread-safe")
  }
  let options = @cares.Options::new(evsys=@cares.Evsys::Default)
  let optmask = @cares.OPT_EVENT_THREAD
  let channel = @cares.Channel::new(options, optmask) catch {
    error => {
      println("Error: \{(error : Error)}")
      return
    }
  }
  let hints = @cares.AddrInfoHints::new(flags=@cares.AI_CANONNAME)
  channel.getaddrinfo(node, service, hints, (_, _, result) => {
    if !result.is_null() {
      for node = result.nodes(); !node.is_null(); node = node.next() {
        match node.family() {
          INET => {
            let buf : FixedArray[Byte] = FixedArray::make(
              @cares.INET_ADDRSTRLEN,
              0,
            )
            node
            .addr()
            .to_sockaddr_in()
            .addr()
            .ntop(buf, @cares.INET_ADDRSTRLEN)
            let addr = @encoding.decode_lossy(
              buf.unsafe_reinterpret_as_bytes(),
              encoding=UTF8,
            )
            let port = node.addr().to_sockaddr_in6().port()
            let port = (port >> 8) | ((port & 0xFF) << 8)
            println("\{addr}:\{port}")
          }
          INET6 => {
            let buf : FixedArray[Byte] = FixedArray::make(
              @cares.INET6_ADDRSTRLEN,
              0,
            )
            node
            .addr()
            .to_sockaddr_in6()
            .addr()
            .ntop(buf, @cares.INET6_ADDRSTRLEN)
            let addr = @encoding.decode_lossy(
              buf.unsafe_reinterpret_as_bytes(),
              encoding=UTF8,
            )
            let port = node.addr().to_sockaddr_in6().port().to_int()
            let port = (port >> 8) | ((port & 0xFF) << 8)
            println("\{addr}:\{port}")
          }
          _ => continue
        }
      }
    }
    result.free()
  })
  @cares.queue_wait_empty(channel, -1) catch {
    error => println("@cares.queue_wait_empty: \{(error : Error)}")
  }
}
