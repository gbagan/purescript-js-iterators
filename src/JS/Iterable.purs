module JS.Iterable
  ( Iterable
  , count
  , count'
  , fromArray
  , fromString
  , empty
  , filter
  , drop
  , take
  , any
  , all
  , pairwise
  , zip
  , zipWith
  , toArray
  , toLazyList
  )
  where

import Prelude
import Data.Foldable (class Foldable, foldr, foldMapDefaultL)
import Data.Function.Uncurried (Fn4, runFn4)
import Data.Tuple (Tuple(..))
import Data.List.Lazy.Types (List, Step(..))
import Data.Lazy (Lazy, defer)
import Unsafe.Coerce (unsafeCoerce)

foreign import data Iterable :: Type -> Type

instance Functor Iterable where
  map = mapImpl

instance Apply Iterable where
  apply = ap

instance Bind Iterable where
  bind = flip concatMap

instance Applicative Iterable where
  pure = singleton

instance Monad Iterable

instance Semigroup (Iterable a) where
  append = appendImpl

instance Monoid (Iterable a) where
  mempty = empty

instance Foldable Iterable where
  foldl = foldlImpl
  foldr f a = foldr f a <<< toArray
  foldMap = foldMapDefaultL

foreign import countImpl :: Int -> Int -> Iterable Int

count :: Int -> Iterable Int
count n = countImpl n 1

count' :: Int -> Int -> Iterable Int
count' = countImpl

foreign import mapImpl :: forall a b. (a -> b) -> Iterable a -> Iterable b

foreign import concatMap :: forall a b. (a -> Iterable b) -> Iterable a -> Iterable b
foreign import singleton :: forall a. a -> Iterable a

foreign import empty :: forall a. Iterable a

foreign import appendImpl :: forall a. Iterable a -> Iterable a -> Iterable a

foreign import foldlImpl :: forall b a. (b -> a -> b) -> b -> Iterable a -> b

foreign import filter :: forall a. (a -> Boolean) -> Iterable a -> Iterable a


foreign import pairwiseImpl :: forall a. (a -> a -> Tuple a a) -> Iterable a -> Iterable (Tuple a a)

foreign import take :: forall a. Int -> Iterable a -> Iterable a

foreign import drop :: forall a. Int -> Iterable a -> Iterable a

foreign import all :: forall a. (a -> Boolean) -> Iterable a -> Boolean

foreign import any :: forall a. (a -> Boolean) -> Iterable a -> Boolean

pairwise :: forall a. Iterable a -> Iterable (Tuple a a)
pairwise = pairwiseImpl Tuple

foreign import zipWith :: forall a b c. (a -> b -> c) -> Iterable a -> Iterable b -> Iterable c

zip :: forall a b. Iterable a -> Iterable b -> Iterable (Tuple a b)
zip = zipWith Tuple

fromArray :: forall a. Array a -> Iterable a
fromArray = unsafeCoerce

fromString :: String -> Iterable Char
fromString = unsafeCoerce

foreign import toArray :: forall a. Iterable a -> Array a

toLazyList :: forall a. Iterable a -> List a
toLazyList it = runFn4 toLazyListImpl it defer Nil Cons

foreign import toLazyListImpl :: forall b.
  Fn4
    (Iterable b)
    (forall a. (Unit -> a) -> Lazy a)
    (forall a. Step a)
    (forall a. a -> List a -> Step a)
    (List b)