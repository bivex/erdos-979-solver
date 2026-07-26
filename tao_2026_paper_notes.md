# 📄 Paper Reference: Local Bernstein Theory & Lower Bounds for Lebesgue Constants

> **Author:** Terence Tao (UCLA, 2026)  
> **Title:** Local Bernstein theory, and lower bounds for Lebesgue constants  
> **Erdős Problems Context:** [Erdős Problem #1132](https://www.erdosproblems.com/1132), [Problem #1129](https://www.erdosproblems.com/1129), [Problem #1153](https://www.erdosproblems.com/1153)  
> **MSC Classification:** 41A05, 42A15, 30D15

---

## 📌 Abstract & Main Results

Classical (global) Bernstein theory bounds entire functions of exponential type on $\mathbb{R}$. Tao localizes this theory to rectangular regions $R_+(I, y_0) = \{x+iy : x \in I, 0 \le y \le y_0\}$, establishing quantitative local Bernstein-type bounds with acceptable error terms.

### Key Theorems

#### 1. Local Bernstein Bounds (Theorem 1.6)
For a function $f$ holomorphic on $R_+(I, y_0)$ obeying $L^\infty$ bounds $A$ on the lower edge, exponential bounds $A e^{\lambda y_0}$ on the upper edge, and double-exponential bounds on vertical sides:

- **Local Bernstein inequality:**
  $$|f'(x)| \le A \lambda \left(1 + O(e^{-\pi L / 4y_0}) + O\left(\frac{1}{\lambda \min(y_0, L)}\right)\right)$$

- **Local Boas inequality:**
  $$\left|f(x) + i \frac{f'(x)}{\lambda}\right| \le A \left(1 + O(e^{-\pi L / 4y_0}) + O\left(\frac{1}{\lambda \min(y_0, L)}\right)\right)$$

#### 2. Resolution of Erdős-Turán Questions (Theorem 1.10)
Let $I \subset [-1, 1]$ be a fixed subinterval, and $\lambda(x) = \sum_{k=1}^n |\ell_k(x)|$ be the Lebesgue function for arbitrary nodes $-1 \le x_1 < \dots < x_n \le 1$:

- **Sup norm lower bound (Theorem 1.10(i)):**
  $$\sup_{x \in I} \lambda(x) \ge \frac{2}{\pi} \log n - O(1)$$
  *(Answers the long-standing question of Erdős & Turán [1961] with an optimal $O(1)$ error term).*

- **Integral lower bound (Theorem 1.10(ii)):**
  $$\int_I \lambda(x) \, dx \ge \frac{4 |I|}{\pi^2} \log n - o(\log n)$$
  $$\int_{-1}^1 \lambda(x) \, dx \ge \frac{8}{\pi^2} \log n - o(\log n)$$
  *(Confirms Erdős's asymptotic integral conjecture).*

#### 3. Pointwise Lower Bounds for Problem #1132 (Corollary 1.11)
For any function $\omega(n) \to \infty$ as $n \to \infty$ (e.g. $\omega(n) = \log\log\log n$), there exists a **dense (and comeager) set** of points $x^* \in [-1, 1]$ such that:

$$\lambda^{(n)}(x^*) \ge \frac{2}{\pi} \log n - \omega(n) \quad \text{for infinitely many } n.$$

---

## 🛠️ AI Tools Used in Terence Tao's 2026 Paper
*(As explicitly acknowledged in Section 1.7 of Terence Tao's paper)*:
- **AlphaEvolve & ChatGPT Pro**: Discovered the proof of Trigonometric Toy Model (Theorem 1.13 via Lemma 1.14).
- **GPT & Nat Sothanaphan**: Supplied rigorously proven versions of logarithmic potential bounds (Theorem 4.1(i)).
- **ChatGPT DeepResearch, Gemini DeepResearch, Claude**: Located references.
- **Claude Code & GitHub Copilot**: Typesetting and code completions.
- **Gemini**: Generated plots (Figures 1, 2, 5, 6, 7, 8, 9, 10, 11, 12).
