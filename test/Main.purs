module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import Data.Foldable (foldl)
import Data.Int (odd)
import Data.Maybe (Maybe(..))
import Control.Monad.ST as ST
import JS.Iterable as I
import JS.Iterator.ST as STI

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  let a = I.fromArray [1, 2, 3, 4, 5]
  let b = I.fromArray [6, 7]
  let s = I.fromString "hello"
  describe "Data.Iterable" do
    it "fromArray >>> toArray == id" do
      I.toArray a `shouldEqual` [1, 2, 3, 4, 5]
    it "fromString" do
      I.toArray s `shouldEqual` ['h', 'e', 'l', 'l', 'o']
    it "map" do
      I.toArray (map (_ * 2) a) `shouldEqual` [2, 4, 6, 8, 10]
    it "pure" do
      I.toArray (pure 2) `shouldEqual` [2]
    it ">>=" do
      I.toArray (a >>= \n -> I.fromArray [n*2, n*3]) `shouldEqual` [2, 3, 4, 6, 6, 9, 8, 12, 10, 15]
    it "<>" do
      I.toArray (a <> b) `shouldEqual` [1, 2, 3, 4, 5, 6, 7] 
    it "mempty" do
      I.toArray mempty `shouldEqual` ([] :: Array Int)
    it "foldl" do
      foldl (\acc x -> acc <> show x) "" a `shouldEqual` "12345"
    it "filter" do
      I.toArray (I.filter odd a) `shouldEqual` [1, 3, 5]
    it "drop" do
      I.toArray (I.drop 2 a) `shouldEqual` [3, 4, 5]
    it "drop n it with n negative" do
        I.toArray (I.drop (-3) a) `shouldEqual` [1, 2, 3, 4, 5]
    it "drop n it with n > length it" do
        I.toArray (I.drop 6 a) `shouldEqual` []
    it "take" do
      I.toArray (I.take 2 a) `shouldEqual` [1, 2]
    it "take n it with n negative" do
        I.toArray (I.take (-3) a) `shouldEqual` []
    it "take n it with n > length it" do
        I.toArray (I.take 6 a) `shouldEqual` [1, 2, 3, 4, 5]
    it "count'" do
        I.toArray (I.take 4 (I.count' 3 2)) `shouldEqual` [3, 5, 7, 9]
  describe "Data.ST.Iterator" do
    it "first element" do
      let v = ST.run do
                sti <- STI.iterator a
                STI.next sti
      v `shouldEqual` Just 1
    it "second element" do
      let v = ST.run do
                sti <- STI.iterator a
                _ <- STI.next sti
                STI.next sti
      v `shouldEqual` Just 2
    it "exhaust the iterator" do
      let v = ST.run do
                sti <- STI.iterator a
                _ <- STI.next sti
                _ <- STI.next sti
                _ <- STI.next sti
                _ <- STI.next sti
                _ <- STI.next sti
                _ <- STI.next sti
                STI.next sti
      v `shouldEqual` Nothing