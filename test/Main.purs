module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import Data.Int (odd)
import Data.Iterable as I

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  describe "Data.Iterable" do
    let a = I.fromArray [1, 2, 3, 4, 5]
    it "fromArray >>> toArray == id" do
      I.toArray a `shouldEqual` [1, 2, 3, 4, 5]
    it "map" do
      I.toArray (map (_ * 2) a) `shouldEqual` [2, 4, 6, 8, 10]
    it "pure" do
      I.toArray (pure 2) `shouldEqual` [2]
    it ">>=" do
      I.toArray (a >>= \n -> I.fromArray [n*2, n*3]) `shouldEqual` [2, 3, 4, 6, 6, 9, 8, 12, 10, 15]
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