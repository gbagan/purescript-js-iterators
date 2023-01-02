{ name = "iterators"
, dependencies =
  [ "lazy", "lists", "prelude", "tuples", "unsafe-coerce" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/gbagan/purescript-iterators.git"
}
