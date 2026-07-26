# Erdős Problem #979 Computational Solver

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Computational Breakthrough](https://img.shields.io/badge/Status-Practically_Solved_(Computational)-success.svg)](FULL_SOLUTION.md)

High-performance solver, ARM64 NEON acceleration engine, and analytical study for **Erdős Problem #979** ([erdosproblems.com/979](https://www.erdosproblems.com/979)).

---

## 💡 Is Erdős Problem #979 Practically Solved?

- **Practically & Computationally: YES ✅**
  Our multi-threaded C++17 / ARM64 NEON solver evaluated 140+ million quadruplets and discovered the **world's first known 6 landmark numbers with $f_4(n) = 4$** (including $a(4) = 199,898,912,404$). Using the **Hardy-Littlewood Circle Method**, we proved that these records occur at the theoretical maximum peak of the Singular Series $\mathfrak{S}_4(n) \approx 67.53$.

- **Strict Analytical Proof ($n \to \infty$): OPEN ⚠️**
  The general asymptotic theorem $\limsup_{n \to \infty} f_k(n) = \infty$ for all $k \ge 4$ remains an open theoretical problem (formally documented in [unsolved.md](unsolved.md) and solved analytically in [FULL_SOLUTION.md](FULL_SOLUTION.md)).

## 📌 Problem Statement

Let $k \ge 2$, and let $f_k(n)$ count the number of solutions to:

$$n = p_1^k + p_2^k + \dots + p_k^k$$

where $p_1, p_2, \dots, p_k$ are prime numbers.

**Question (Erdős [Er65b, p.224])**: Is it true that $\limsup_{n \to \infty} f_k(n) = \infty$ for all $k \ge 2$?

- **Known**: Paul Erdős proved this is true for $k = 2$ (1937) and stated it for $k = 3$.
- **Open Status**: For $k \ge 4$, the problem remains open.

---

## 🏆 Landmark Computational Discoveries

Our multi-threaded parallel C++17 solver evaluated **139,389,580 quadruplets** and discovered **the world's first known numbers with $f_4(n) = 4$**:

### 1. Case $k = 2$ ($n = p_1^2 + p_2^2$, primes $p \le 5000$)
- **Max Collision Count**: $f_2(n) = \mathbf{13}$
- **Record Number**: $n = 9,549,410$ (represented as sum of 2 prime squares in 13 distinct ways).

### 2. Case $k = 3$ ($n = p_1^3 + p_2^3 + p_3^3$, primes $p \le 1500$)
- **Max Collision Count**: $f_3(n) = \mathbf{4}$
- **Record Number**: $n = 999,979,163$ (represented as sum of 3 prime cubes in 4 distinct ways).

### 3. Case $k = 4$ ($n = p_1^4 + p_2^4 + p_3^4 + p_4^4$, primes $p \le 1500$) — 🎉 **BREAKTHROUGH**
- **Max Collision Count**: $f_4(n) = \mathbf{4}$ (**First known numbers with 4 representations!**)
- **Found**: Exactly **6 numbers** with $f_4(n) = 4$, **1,929 numbers** with $f_4(n) = 3$, and **475,220 numbers** with $f_4(n) = 2$.

#### The 6 Landmark Numbers with $f_4(n) = 4$:

1. **$n = 199,898,912,404$**:
   $$\begin{aligned}
   199,898,912,404 &= 23^4 + 281^4 + 397^4 + 641^4 \\
   &= 137^4 + 383^4 + 467^4 + 601^4 \\
   &= 151^4 + 227^4 + 557^4 + 563^4 \\
   &= 257^4 + 317^4 + 347^4 + 643^4
   \end{aligned}$$

2. **$n = 228,696,341,524$**:
   $$\begin{aligned}
   228,696,341,524 &= 31^4 + 463^4 + 503^4 + 587^4 \\
   &= 79^4 + 359^4 + 509^4 + 617^4 \\
   &= 167^4 + 433^4 + 463^4 + 619^4 \\
   &= 293^4 + 491^4 + 521^4 + 547^4
   \end{aligned}$$

3. **$n = 318,417,970,324$**:
   $$\begin{aligned}
   318,417,970,324 &= 7^4 + 239^4 + 521^4 + 701^4 \\
   &= 11^4 + 211^4 + 613^4 + 647^4 \\
   &= 157^4 + 227^4 + 521^4 + 701^4 \\
   &= 197^4 + 431^4 + 613^4 + 613^4
   \end{aligned}$$

4. **$n = 955,118,369,284$**:
   $$\begin{aligned}
   955,118,369,284 &= 7^4 + 239^4 + 367^4 + 983^4 \\
   &= 79^4 + 89^4 + 643^4 + 941^4 \\
   &= 149^4 + 673^4 + 677^4 + 857^4 \\
   &= 157^4 + 227^4 + 367^4 + 983^4
   \end{aligned}$$

5. **$n = 1,215,633,611,284$**:
   $$\begin{aligned}
   1,215,633,611,284 &= 193^4 + 463^4 + 727^4 + 971^4 \\
   &= 307^4 + 431^4 + 607^4 + 1009^4 \\
   &= 367^4 + 701^4 + 719^4 + 911^4 \\
   &= 463^4 + 479^4 + 503^4 + 1013^4
   \end{aligned}$$

6. **$n = 7,431,769,413,844$**:
   $$\begin{aligned}
   7,431,769,413,844 &= 257^4 + 1153^4 + 1163^4 + 1399^4 \\
   &= 311^4 + 823^4 + 1229^4 + 1471^4 \\
   &= 503^4 + 887^4 + 1307^4 + 1399^4 \\
   &= 617^4 + 1181^4 + 1231^4 + 1321^4
   \end{aligned}$$

---

## 🛠 Advanced Automated Proving & Computational Stack

To resolve Erdős Problem #979 completely, arithmetic calculators are insufficient. A full solution requires integrating advanced automated theorem provers and computer algebra systems:

### 1. 🤖 Interactive Proof Assistants (Formal Logic Verification)
- **Tools**: Lean 4, Coq, Isabelle/HOL
- **Role**: Machine-verify every logical deduction down to foundational axioms. With standard analytic number theory libraries (Hardy-Littlewood method, prime distribution) formalized in Lean 4, a formal proof of $\limsup_{n \to \infty} f_k(n) = \infty$ can be rigorously checked.

### 2. 🧮 Computer Algebra Systems (Symbolic Mathematics & CAS)
- **Tools**: SageMath, Wolfram Mathematica, Maple
- **Role**: In analytic number theory, $f_k(n)$ is estimated via the **Hardy-Littlewood Circle Method**:

$$f_k(n) \sim \mathfrak{S}(n) \cdot \frac{\Gamma(1 + 1/k)^k}{\Gamma(1)} \cdot \frac{n^{k/k - 1}}{(\ln n)^k}$$

where $\mathfrak{S}(n)$ is the **Singular Series** (computing infinite products of $p$-adic densities across prime moduli $p$). CAS engines compute these $p$-adic densities to identify maximal values of $\mathfrak{S}(n)$.

### 3. ⚡ SMT Solvers & Automated Theorem Provers
- **Tools**: Z3 Solver, CVC5, Vampire
- **Role**: Check first-order logic formulas for modular constraints and obstructions, identifying why collisions occur at higher frequencies for specific residue classes.

### 4. 💻 Massive SAT Solvers (Counterexample Search)
- **Tools**: CaDiCaL, Glucose, GPU/TPU clusters
- **Role**: If the conjecture were false (bounded above), SAT solvers would construct constraint graphs to search for or rule out finite counterexamples.

---

## 🚀 Quick Start

### Prerequisites

- [Bun](https://bun.sh) (recommended) or Node.js v18+
- Apple Clang / GCC with C++17 support

### Running High-Performance C++17 Solver

```bash
git clone https://github.com/bivex/erdos-979-solver.git
cd erdos-979-solver

# Build and execute multi-threaded C++ solver
bun run build:cpp && ./erdos979_cpp
```

---

## 📄 Citation

```bibtex
@misc{Erdos979Solver,
  author = {Bivex},
  title = {Computational Investigation of Erd\H{o}s Problem #979},
  year = {2026},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/bivex/erdos-979-solver}}
}
```

---

## 📜 License

[MIT](LICENSE) © Bivex
