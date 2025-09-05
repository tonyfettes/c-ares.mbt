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
        if node.family() == @inet.address_family {
          let sin : @inet.Sockaddr? = node.addr().to()
          guard sin is Some(sin)
          let socket = @socket.socket(
            node.family(),
            node.socktype(),
            node.protocol(),
          )
          ignore(socket.connect(sin))
        } else if node.family() == @inet6.address_family {
          let sin6 : @inet6.Sockaddr? = node.addr().to()
          guard sin6 is Some(sin6)
          let socket = @socket.socket(
            node.family(),
            node.socktype(),
            node.protocol(),
          )
          ignore(socket.connect(sin6))
        } else {
          println("Unknown address family: \{(node.family())}")
        }
      }
    }
    result.free()
  })
  @cares.queue_wait_empty(channel, -1) catch {
    error => println("@cares.queue_wait_empty: \{(error : Error)}")
  }
}
