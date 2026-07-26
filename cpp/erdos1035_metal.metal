#include <metal_stdlib>
using namespace metal;

// Metal GPU kernel for Erdős Problem #1035
// Verifies if host graphs G on 2^n vertices with min degree delta(G) >= (1-c)*2^n
// contain hypercube Q_n as a spanning subgraph via parallel GPU permutation search.

kernel void erdos1035_embedding_kernel(
    device const uint32_t* adj_matrix [[buffer(0)]],
    device uint32_t* embedding_found [[buffer(1)]],
    device const uint32_t* n_ptr [[buffer(2)]],
    uint thread_idx [[thread_position_in_grid]]
) {
    uint n = *n_ptr;
    uint N = 1u << n;
    
    if (N > 32) return; // N <= 32 (n <= 5) for thread local array stack
    
    uint seed = thread_idx * 1664525u + 1013904223u;
    uint map_verts[32];
    
    for (uint i = 0; i < N; ++i) {
        map_verts[i] = i;
    }
    
    // Fisher-Yates random shuffle on GPU thread
    for (uint i = N - 1; i > 0; --i) {
        seed = seed * 1103515245u + 12345u;
        uint j = seed % (i + 1);
        uint tmp = map_verts[i];
        map_verts[i] = map_verts[j];
        map_verts[j] = tmp;
    }
    
    // Verify Q_n edge preservation in host graph G
    bool valid = true;
    for (uint u = 0; u < N; ++u) {
        uint mapped_u = map_verts[u];
        for (uint b = 0; b < n; ++b) {
            uint v = u ^ (1u << b);
            if (u < v) {
                uint mapped_v = map_verts[v];
                if (adj_matrix[mapped_u * N + mapped_v] == 0) {
                    valid = false;
                    break;
                }
            }
        }
        if (!valid) break;
    }
    
    if (valid) {
        atomic_store_explicit((device atomic_uint*)embedding_found, 1, memory_order_relaxed);
    }
}
