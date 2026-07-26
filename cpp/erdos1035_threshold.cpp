#include <iostream>
#include <vector>
#include <numeric>
#include <algorithm>
#include <chrono>

// C++ High-Speed Subgraph Isomorphism & Threshold Analysis for Erdős #1035

struct Graph {
    int N;
    std::vector<uint32_t> adj; // Bitset adjacency
    Graph(int n) : N(n), adj(n, 0) {}
    void add_edge(int u, int v) {
        adj[u] |= (1u << v);
        adj[v] |= (1u << u);
    }
    bool has_edge(int u, int v) const {
        return (adj[u] & (1u << v)) != 0;
    }
};

Graph build_q_n(int n) {
    int N = 1 << n;
    Graph Q(N);
    for (int u = 0; u < N; ++u) {
        for (int bit = 0; bit < n; ++bit) {
            int v = u ^ (1 << bit);
            if (u < v) Q.add_edge(u, v);
        }
    }
    return Q;
}

bool backtrack_embed(const Graph& Q, const Graph& G, std::vector<int>& map, std::vector<bool>& used, int u) {
    if (u == Q.N) return true;

    for (int v = 0; v < G.N; ++v) {
        if (used[v]) continue;

        // Check if v is connected to all already mapped neighbors of u in Q
        bool valid = true;
        for (int nu = 0; nu < u; ++nu) {
            if (Q.has_edge(u, nu)) {
                int nv = map[nu];
                if (!G.has_edge(v, nv)) {
                    valid = false;
                    break;
                }
            }
        }

        if (valid) {
            map[u] = v;
            used[v] = true;
            if (backtrack_embed(Q, G, map, used, u + 1)) return true;
            used[v] = false;
        }
    }
    return false;
}

bool can_embed(const Graph& Q, const Graph& G) {
    std::vector<int> map(Q.N, -1);
    std::vector<bool> used(G.N, false);
    return backtrack_embed(Q, G, map, used, 0);
}

int main() {
    std::cout << "=========================================================================\n";
    std::cout << "  C++ HIGH-SPEED CRITICAL THRESHOLD ANALYSIS FOR ERDŐS #1035\n";
    std::cout << "=========================================================================\n\n";

    for (int n = 2; n <= 4; ++n) {
        int N = 1 << n;
        Graph Q = build_q_n(n);
        std::cout << "--- Dimension n = " << n << " (N = " << N << " vertices, Q_" << n << " has " << n * (N/2) << " edges) ---\n";

        // Test Complete Bipartite K_{N/2, N/2}
        Graph K_bip(N);
        for (int i = 0; i < N / 2; ++i) {
            for (int j = N / 2; j < N; ++j) {
                K_bip.add_edge(i, j);
            }
        }
        bool bip_embed = can_embed(Q, K_bip);
        std::cout << "  Complete Bipartite K_{" << N/2 << "," << N/2 << "} (min_deg = " << N/2 << "): Q_" << n << " embedded? " 
                  << (bip_embed ? "YES ✅" : "NO ❌") << "\n";

        // Test Host Graphs G with degree deficit
        for (int deficit = 0; deficit <= N / 4; ++deficit) {
            Graph G_host(N);
            // Complete graph minus deficit matchings
            for (int i = 0; i < N; ++i) {
                for (int j = i + 1; j < N; ++j) {
                    G_host.add_edge(i, j);
                }
            }
            if (deficit > 0) {
                for (int d = 1; d <= deficit; ++d) {
                    for (int i = 0; i < N; ++i) {
                        int j = (i + d) % N;
                        G_host.adj[i] &= ~(1u << j);
                        G_host.adj[j] &= ~(1u << i);
                    }
                }
            }
            int min_d = N - 1 - deficit;
            bool embed = can_embed(Q, G_host);
            std::cout << "  Host Graph G (min_deg = " << min_d << "/" << N << ", deficit = " << deficit << "): Q_" << n << " embedded? " 
                      << (embed ? "YES ✅" : "NO ❌") << "\n";
        }
        std::cout << "\n";
    }

    return 0;
}
