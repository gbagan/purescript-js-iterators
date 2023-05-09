module JS.Iterator.ST where

import Control.Monad.ST (ST, Region)
import Control.Monad.ST.Uncurried (STFn3, runSTFn3)
import JS.Iterable (Iterable)
import Data.Maybe (Maybe(..))

foreign import data Iterator :: Region -> Type -> Type

foreign import iterator :: forall r a. Iterable a -> ST r (Iterator r a)

foreign import nextImpl :: forall r a. STFn3 (Iterator r a) (Maybe a) (a -> Maybe a) r (Maybe a)

next :: forall r a. Iterator r a -> ST r (Maybe a)
next it = runSTFn3 nextImpl it Nothing Just