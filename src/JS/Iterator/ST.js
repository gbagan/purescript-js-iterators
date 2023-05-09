export const iterator = xs => () => xs[Symbol.iterator]()

export const nextImpl = (it, nothing, just) => {
  const {value, done} = it.next()
  return done ? nothing : just(value)
}