"""
Erdős Problem #1035: Subgraph Monomorphism Threshold Analysis
"""

import networkx as nx

def build_q_n(n):
    """Build hypercube Q_n with integer vertices 0..2^n-1."""
    N = 1 << n
    G = nx.Graph()
    G.add_nodes_from(range(N))
    for u in range(N):
        for bit in range(n):
            v = u ^ (1 << bit)
            if u < v:
                G.add_edge(u, v)
    return G

def check_embedding(G_host, Q_n):
    """Check if Q_n embeds into G_host as a subgraph."""
    GM = nx.algorithms.isomorphism.GraphMatcher(G_host, Q_n)
    return GM.subgraph_is_monomorphic()

def run_analysis():
    print("=========================================================================")
    print("  EXACT SUBGRAPH EMBEDDING THRESHOLD ANALYSIS FOR ERDŐS #1035")
    print("=========================================================================\n")

    for n in [2, 3, 4]:
        N = 1 << n
        Q_n = build_q_n(n)
        print(f"--- Dimension n = {n} (N = {N} vertices, Q_{n} has {Q_n.number_of_edges()} edges) ---")

        # 1. Test Complete Bipartite Graph K_{N/2, N/2}
        K_bip = nx.complete_bipartite_graph(N // 2, N // 2)
        bip_embed = check_embedding(K_bip, Q_n)
        print(f"  Complete Bipartite K_{{{N//2}, {N//2}}} (min_deg = {N//2}): Q_{n} embedded? {'YES ✅' if bip_embed else 'NO ❌'}")

        # 2. Test Complete Graph K_N minus 1-factor matchings
        min_deg_threshold = N - 1
        for deficit in range(0, N // 2):
            G_host = nx.complete_graph(N)
            
            # Remove 1-factor matchings to create regular deficit
            if deficit > 0:
                for d in range(deficit):
                    shift = d + 1
                    for i in range(N):
                        j = (i + shift) % N
                        if G_host.has_edge(i, j):
                            G_host.remove_edge(i, j)

            min_d = min(dict(G_host.degree()).values())
            embedded = check_embedding(G_host, Q_n)
            print(f"  Host Graph G (min_deg = {min_d}/{N}, deficit = {deficit}): Q_{n} embedded? {'YES ✅' if embedded else 'NO ❌'}")
            if embedded:
                min_deg_threshold = min_d

        c_crit = 1.0 - (min_deg_threshold / float(N))
        print(f"  --> Empirical min degree bound for n={n}: delta(G) >= {min_deg_threshold}/{N} (c_crit <= {c_crit:.4f})\n")

if __name__ == '__main__':
    run_analysis()
