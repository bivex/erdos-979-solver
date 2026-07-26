#include <metal_stdlib>
using namespace metal;

// Metal GPU Kernel for Erdős Problem #1035: Layer-by-Layer Embedding Verification
// Verifies if greedy layer embedding L_0 -> L_1 -> ... -> L_n succeeds without deadlocks

kernel void erdos1035_layer_kernel(
    device const uint32_t* adj_matrix [[buffer(0)]],
    device atomic_uint* success_count [[buffer(1)]],
    device const uint32_t* n_ptr [[buffer(2)]],
    uint thread_idx [[thread_position_in_grid]]
) {
    uint n = *n_ptr;
    uint N = 1u << n;
    if (N > 256) return; // N <= 256 for GPU thread stack

    uint seed = thread_idx * 1664525u + 1013904223u;
    
    // Track mapped vertices: map_Q_to_G[q] = g
    int map_Q[256];
    bool used_G[256];
    for (uint i = 0; i < N; ++i) {
        map_Q[i] = -1;
        used_G[i] = false;
    }

    // Embed L_0 (all zeros vertex)
    seed = seed * 1103515245u + 12345u;
    uint start_v = seed % N;
    map_Q[0] = start_v;
    used_G[start_v] = true;

    bool full_success = true;

    // Embed vertices in topological layer order (1 to N-1)
    for (uint q = 1; q < N; ++q) {
        // Collect mapped neighbors of q in Q_n
        uint candidate_mask = 0xFFFFFFFFu; // Bitmask of valid host vertices in G
        
        for (uint b = 0; b < n; ++b) {
            uint prev = q ^ (1u << b);
            if (prev < q) { // Already mapped ancestor
                uint mapped_prev = map_Q[prev];
                // Intersect with N_G(mapped_prev)
                // Access adjacency matrix row for mapped_prev
                uint valid_neighbors = 0;
                for (uint g = 0; g < N; ++g) {
                    if (adj_matrix[mapped_prev * N + g] != 0 && !used_G[g]) {
                        valid_neighbors |= (1u << g);
                    }
                }
                candidate_mask &= valid_neighbors;
            }
        }

        if (candidate_mask == 0) {
            full_success = false; // Deadlock / trapped vertex
            break;
        }

        // Pick random available candidate vertex in G
        seed = seed * 1103515245u + 12345u;
        // Count bits
        uint num_candidates = popcount(candidate_mask);
        if (num_candidates == 0) {
            full_success = false;
            break;
        }
        
        uint pick_idx = seed % num_candidates;
        uint chosen_g = 0;
        uint current_count = 0;
        for (uint g = 0; g < N; ++g) {
            if ((candidate_mask & (1u << g)) != 0) {
                if (current_count == pick_idx) {
                    chosen_g = g;
                    break;
                }
                current_count++;
            }
        }

        map_Q[q] = chosen_g;
        used_G[chosen_g] = true;
    }

    if (full_success) {
        atomic_fetch_add_explicit(success_count, 1, memory_order_relaxed);
    }
}
