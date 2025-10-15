///|
async fn[T, E : Error] async_suspend(
  cb : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
fn run_async(f : async () -> Unit noraise) = "%async.run"

///|
pub struct AsyncIterator[T] {
  next : async () -> T?
  throws : async (Error) -> T?
  returns : async () -> T?
}

///|
pub async fn[T] AsyncIterator::next(self : AsyncIterator[T]) -> T? {
  (self.next)()
}

///|
pub async fn[T] AsyncIterator::throws(self : AsyncIterator[T], e : Error) -> T? {
  (self.throws)(e)
}

///|
pub async fn[T] AsyncIterator::returns(self : AsyncIterator[T]) -> T? {
  (self.returns)()
}

///|
pub suberror Return

///|
pub fn[T] AsyncIterator::new(
  f : async (async (T) -> Unit) -> Unit,
) -> AsyncIterator[T] {
  let mut next : Result[T?, Error] = Ok(None)
  let mut ok_cont : (Unit) -> Unit = _ => ()
  let mut err_cont : (Error) -> Unit = _ => ()
  async fn yield_(value) {
    async_suspend((resolve, reject) => {
      next = Ok(Some(value))
      ok_cont = resolve
      err_cont = reject
    })
  }

  ok_cont = _ => run_async(fn() {
    defer {
      ok_cont = _ => ()
      err_cont = _ => ()
    }
    try f(yield_) catch {
      Return => ()
      e => next = Err(e)
    } noraise {
      _ => next = Ok(None)
    }
  })
  AsyncIterator::{
    next: fn() {
      next = Ok(None)
      ok_cont(())
      next.unwrap_or_error()
    },
    throws: fn(e) {
      next = Ok(None)
      err_cont(e)
      next.unwrap_or_error()
    },
    returns: fn() {
      next = Ok(None)
      err_cont(Return)
      next.unwrap_or_error()
    },
  }
}
