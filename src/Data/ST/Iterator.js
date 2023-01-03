export const iterator = xs => () => xs[Symbol.iterator]()

export const nextImpl = nothing => just => it => () => {
    const {value, done} = it.next()
    return done ? nothing : just(value)
}