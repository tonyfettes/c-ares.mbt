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

      }
    }
    result.free()
  })
}
