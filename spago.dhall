{ name = "iterators"
, dependencies =
  [ "lazy", "lists", "maybe", "prelude", "st", "tuples", "unsafe-coerce" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/gbagan/purescript-iterators.git"
}
