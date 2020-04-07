(lang dune 2.0)
(name gospel-lru)
(implicit_transitive_deps false)

(generate_opam_files true)
(source (github pascutto/gospel-lru))
(maintainers "Clément Pascutto <clement@tarides.com>")
(authors "Clément Pascutto <clement@tarides.com>")

(package
 (name gospel-lru)
 (synopsis "A verified implementation of simple LRU caches")
 (description "\
A verified implementation of simple LRU caches
")
 (documentation https://pascutto.github.io/gospel-lru/)
 (depends alcotest fmt logs))
