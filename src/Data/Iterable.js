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

export const itmap = f => xs => ({
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
                        m--;
                        return o
                    }
                    return {done: true, value: undefined}
                }
            }
        }
    }
})

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

export const toLazyListImpl = defer => nil => cons => xs => {
    const it = xs[Symbol.iterator]()
    const defered = () => defer(() => {
        const { value, done } = it.next()
        if (done)
            return nil
        else
            return cons(value)(defered())
    })
    return defered()
}