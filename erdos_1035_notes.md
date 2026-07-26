# 📐 Reference: Erdős Problem #1035 (Hypercube Embeddings under Minimum Degree)

> **Erdős Problems Portal:** [Erdős Problem #1035](https://www.erdosproblems.com/1035)  
> **Original Source:** P. Erdős [Er93, p. 345]  
> **Category:** Extremal Graph Theory / Spanning Subgraphs  
> **Status:** OPEN ❌

---

## ❓ Statement of the Conjecture

Is there a universal constant $c > 0$ such that every graph $G$ on $2^n$ vertices with minimum degree:

$$\delta(G) > (1 - c) 2^n$$

contains the $n$-dimensional hypercube $Q_n$ as a spanning subgraph?

---

## 💡 Related Questions by Erdős (1993)

If the main conjecture is false (meaning no fixed $c > 0$ works for all $n$):
1. **Blow-up vertex requirement:** Determine the smallest $m > 2^n$ such that every graph on $m$ vertices with $\delta(G) > (1-c)2^n$ contains $Q_n$.
2. **Sub-linear degree deficit:** Find the maximal function $u_n$ such that $\delta(G) > 2^n - u_n$ guarantees a $Q_n$ embedding.

---

## 🧠 Recent Insights (Zach Hunter & Thomas Bloom, Sept 2025)

- **Blow-up Lemma Connection:** Embedding a spanning bounded-degree bipartite graph $Q_n$ into dense graphs relies on quantitative variants of the **Komlós–Sárközy–Szemerédi Blow-up Lemma**.
- **Tikhomirov Bounds:** For any fixed $c > 0$, techniques by Tikhomirov yield $c' \in (0, c)$ showing that $2^{n(1-c')}$ vertices suffice for large $n$.
