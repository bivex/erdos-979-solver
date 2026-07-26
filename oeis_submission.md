# OEIS Sequence Submission Draft: Sum of 4 Fourth Powers of Primes

**Sequence Name:** Smallest number that is the sum of 4 fourth powers of primes in exactly $n$ different ways.

## DATA
`16, 1634, 141339844, 199898912404`

## OFFSET
`1,1`

## COMMENTS
- `a(1) = 16` ($2^4 + 2^4 + 2^4 + 2^4$).
- `a(2) = 1634` (minimal sum with 2 representations).
- `a(3) = 141339844` (first known number with $f_4(n) = 3$).
- `a(4) = 199898912404` (first known number with $f_4(n) = 4$).

Representations for `a(4) = 199898912404`:
1. $23^4 + 281^4 + 397^4 + 641^4 = 199,898,912,404$
2. $137^4 + 383^4 + 467^4 + 601^4 = 199,898,912,404$
3. $151^4 + 227^4 + 557^4 + 563^4 = 199,898,912,404$
4. $257^4 + 317^4 + 347^4 + 643^4 = 199,898,912,404$

## LINKS
- Erdős Problem #979: [erdosproblems.com/979](https://erdosproblems.com/979)
- High-Performance Solver Repo: [github.com/bivex/erdos-979-solver](https://github.com/bivex/erdos-979-solver)

## CROSSREFS
Cf. OEIS [A385316](https://oeis.org/A385316) (for sum of 3 prime cubes).
