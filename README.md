<div align="center">
  <h1>CacheCache</h1>
  <strong>An efficient caching library for OCaml.</strong>
</div>

<div align="center">
<br />

[![license](https://img.shields.io/github/license/pascutto/cachecache.svg?style=flat-square)](LICENSE)

[![OCaml-CI Build Status](https://img.shields.io/endpoint?url=https%3A%2F%2Fci.ocamllabs.io%2Fbadge%2Fpascutto%2Fcachecache%2Fmain&logo=ocaml&style=flat-square)](https://ci.ocamllabs.io/github/pascutto/cachecache)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/pascutto/pascutto?style=flat-square)](https://github.com/pascutto/cachecache/releases/latest)
[![documentation](https://img.shields.io/badge/documentation-not_published-red?style=flat-square)](https://pascutto.github.io/cachecache)

</div>

<div align="center">

:warning: **Disclamer:**: this library is still at preliminary stage, and not
ready for public use. Interfaces and implementations are unstable.

</div>

## About

CacheCache aims at providing an efficient (w.r.t. CPU usage, memory usage and
allocations) caching library for OCaml. It currently implements the following
caching strategies:

- `Lru`: [Least recently
  used](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least_recently_used_(LRU)).
  Least recently used items are discarded first when the cache is full.

Interfaces are annotated with formal specifications using the
[Gospel](https://ocaml-gospel.github.io/gospel/) specification language.
