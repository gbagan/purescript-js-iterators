module Data.ST.Iterator where

import Control.Monad.ST (ST, Region)
import Data.Iterable (Iterable)
import Data.Maybe (Maybe(..))

foreign import data Iterator :: Region -> Type -> Type

foreign import iterator :: forall r a. Iterable a -> ST r (Iterator r a)

foreign import nextImpl :: forall r a. Maybe a -> (a -> Maybe a) -> Iterator r a -> ST r (Maybe a)

next :: forall r a. Iterator r a -> ST r (Maybe a)
next = nextImpl Nothing Just