# purescript-js-iterators

ffi bindings for JavaScript's [iterators, iterables and generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols).
It also contains functions inspired by [Python itertools](https://docs.python.org/3/library/itertools.html) and
Scala iterators.

### Documentation

Documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-js-iterators)

### Install

```
spago install js-iterators
```

### Example

Consider the following javascript function

```js
const counter = function*(n) {
  let m = n;
  while(true) {
    yield m;
    m += 1; 
  }
}
```

The type of the function in Purescript will be

```purescript
foreign import counter :: Int -> Iterable Int
```

You can manipulate iterables via functions in `JS.Iterables`
For example,

```purescript
import JS.Iterale as I

a :: Array Int
a = I.toArray $ I.take 5 $ counter 10
-- a = [10, 11, 12, 13, 14]
```

You can also manipulate iterators via the `ST` monad

```purescript
import Control.Monad.ST as ST
import JS.Iterale as I
import JS.Iterator.ST as STI

a :: Int
a = ST.run (do
  it <- STI.iterator $ counter 10
  _ <- STI.next it
  _ <- STI.next it
  STI.next it
)
-- a = 12
```
