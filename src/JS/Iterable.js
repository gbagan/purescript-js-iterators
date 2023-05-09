export const countImpl = start => step => ({
    [Symbol.iterator]() {
        let n = start - step
        return {
            next() {
                n += step
                return { done: false, value: n }
            }
        }
    }
})

export const mapImpl = f => xs => ({
    [Symbol.iterator]() {
        const it = xs[Symbol.iterator]()
        return {
            next() {
                const o = it.next()
                if (o.done) return o
                return { done: false, value: f(o.value) }
            }
        }
    }
})

export const filter = f => xs => ({
    [Symbol.iterator]() {
        const it = xs[Symbol.iterator]()
        return {
            next() {
                for (;;) {
                    const o = it.next()
                    if (o.done || f(o.value))
                        return o;
                }
            }
        }
    }
})

export const empty = ({
    [Symbol.iterator]() {
        return {
            next() {
                return {done: true, value: undefined}
            }
        }
    }
})

export const appendImpl = xs => ys => ({
    [Symbol.iterator]() {
        const it1 = xs[Symbol.iterator]()
        const it2 = ys[Symbol.iterator]()
        return {
            next() {
                const v = it1.next()
                return v.done ? it2.next() : v
            }
        }
    }
})

export const foldlImpl = f => a => xs => {
    let acc = a
    for (const x of xs) {
        acc = f(acc)(x)
    }
    return acc
}

export const singleton = function*(x) {
    yield x;
}

export const concatMap = f => xs => ({
    [Symbol.iterator]() {
        const outer = xs[Symbol.iterator]()
        let inner
        return {
            next() {
                for (;;) {
                    if (inner) {
                        const i = inner.next()
                        if (!i.done) return i
                    }
                    const o = outer.next()
                    if (o.done) {
                        return {
                            done: true,
                            value: undefined,
                        };
                    }
                    inner = f(o.value)[Symbol.iterator]();
                }
            }
        }
    }
})

export const drop = n => xs => ({
    [Symbol.iterator]() {
        const it = xs[Symbol.iterator]()
        let m = Math.max(n, 0)
        return {
            next() {
                for (;;) {
                    const o = it.next()
                    if (o.done || m == 0)
                        return o
                    if (m == 0)
                        return o
                    m--      
                }
            }
        }
    }
})

export const take = n => xs => ({
    [Symbol.iterator]() {
        const it = xs[Symbol.iterator]()
        let m = n
        return {
            next() {
                for (;;) {
                    const o = it.next();
                    if (o.done)
                        return o
                    if (m > 0) {
                        m--
                        return o
                    }
                    return {done: true, value: undefined}
                }
            }
        }
    }
})

export const all = f => xs => {
    for (const x in xs) {
        if (!f(x)) {
            return false;
        }
    }
    return true;
}

export const any = f => xs => {
    for (const x in xs) {
        if (f(x)) {
            return true;
        }
    }
    return false;
}

export const pairwiseImpl = tuple => xs => ({
    [Symbol.iterator]() {
        const it = xs[Symbol.iterator]()
        let prev
        return {
            next() {
                for (;;) {
                    const o = it.next();
                    if (o.done)
                        return o;
                    if (prev !== undefined) {
                        const v = tuple(prev)(o.value)
                        prev = o.value
                        return {value: v, done: false}
                    }
                    prev = o.value         
                }
            }
        }
    }
})

export const zipWith = f => xs => ys => ({
    [Symbol.iterator]() {
        const it1 = xs[Symbol.iterator]()
        const it2 = ys[Symbol.iterator]()
        return {
            next() {
                const o1 = it1.next()
                const o2 = it2.next()
                if (o1.done || o2.done)
                    return {done: true, value: undefined}
                return {value: f(o1.value)(o2.value), v, done: false}
            }
        }
    }
})

export const toArray = xs => [...xs]

export const toLazyListImpl = (xs, defer, nil, cons) => {
  const it = xs[Symbol.iterator]()
  const defered = () => defer(() => {
    const { value, done } = it.next()
    return done ? nil : cons(value)(defered())
  })
  return defered()
}