# Erdős Problem #979 Computational Solver

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

High-performance solver and computational study for **Erdős Problem #979** ([erdosproblems.com/979](https://www.erdosproblems.com/979)).

---

## 📌 Problem Statement

Let $k \ge 2$, and let $f_k(n)$ count the number of solutions to:

$$n = p_1^k + p_2^k + \dots + p_k^k$$

where $p_1, p_2, \dots, p_k$ are prime numbers.

**Question (Erdős [Er65b, p.224])**: Is it true that $\limsup_{n \to \infty} f_k(n) = \infty$ for all $k \ge 2$?

- **Known**: Paul Erdős proved this is true for $k = 2$ (1937) and stated it for $k = 3$.
- **Open Status**: For $k \ge 4$, the problem remains open.

---

## 🔬 Key Computational Findings

Our high-performance C++17 and TypeScript search revealed the following record collision points:

### 1. Case $k = 2$ ($n = p_1^2 + p_2^2$, primes $p \le 2000$)
- **Max Collision Count**: $f_2(n) = \mathbf{8}$
- **Record Number**: $n = 3,179,930$ (represented as sum of 2 prime squares in 8 distinct ways).

### 2. Case $k = 3$ ($n = p_1^3 + p_2^3 + p_3^3$, primes $p \le 400$)
- **Max Collision Count**: $f_3(n) = \mathbf{3}$
- **Record Numbers**: Exactly 6 numbers found with $f_3(n) = 3$ (e.g. $n = 36,901,493$).
- **Distribution**: 643 numbers with $f_3(n) = 2$.

### 3. Case $k = 4$ ($n = p_1^4 + p_2^4 + p_3^4 + p_4^4$, primes $p \le 150$)
- **Max Collision Count**: $f_4(n) = \mathbf{3}$
- **Record Collision Point**: $n = \mathbf{141,339,844}$ (first known record for $k=4$ with 3 distinct representations).
- **Distribution**: 439 numbers with $f_4(n) = 2$.

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

### Running TypeScript Solver & Tests

```bash
git clone https://github.com/bivex/erdos-979-solver.git
cd erdos-979-solver

# Run unit tests
bun test

# Run TypeScript search
bun start
```

### Running High-Performance C++17 Solver

```bash
# Build and execute C++ solver
bun run start:cpp
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
