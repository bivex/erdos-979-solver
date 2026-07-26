"""
Erdős Problem #1035: Hamming Layer Decomposition & Neighborhood Intersection Simulator
Simulates layer-by-layer embedding L_0 -> L_1 -> ... -> L_n and computes intersection capacity.
"""

import math

def binom(n, k):
    return math.comb(n, k)

def analyze_layer_capacities(n, c_val):
    N = 1 << n
    print(f"=========================================================================")
    print(f"  HAMMING LAYER EMBEDDING ANALYSIS FOR n = {n} (N = {N}, c = {c_val:.3f})")
    print(f"=========================================================================\n")

    print("Layer breakdown and minimum neighborhood intersection bounds:")
    print("  Layer k | Size |L_k| = (n choose k) | Degree to L_{k+1} | Min Intersection Capacity")
    print("  -----------------------------------------------------------------------------")

    used_vertices = 0
    all_layers_valid = True

    for k in range(n):
        layer_size = binom(n, k)
        next_layer_size = binom(n, k + 1)
        in_degree_from_prev = k + 1 # Number of edges from L_k into each vertex in L_{k+1}

        # Min degree in G is delta(G) >= (1 - c)*N
        # By Inclusion-Exclusion, intersection of (k+1) neighborhoods in G has size >= (1 - (k+1)*c)*N
        min_intersection = max(0, int((1.0 - (k + 1) * c_val) * N))

        # Remaining free vertices in G not used by previous layers L_0 .. L_k
        used_vertices += layer_size
        remaining_in_G = N - used_vertices

        # Capacity available for embedding vertices in L_{k+1}
        effective_capacity = min(min_intersection, remaining_in_G)

        is_valid = effective_capacity >= next_layer_size
        if not is_valid:
            all_layers_valid = False

        status = "OK ✅" if is_valid else "BOTTLENECK ❌"
        print(f"  L_{k:2d} -> L_{k+1:2d} | {layer_size:14d} | {in_degree_from_prev:17d} | {effective_capacity:25d} ({status})")

    print("\n-------------------------------------------------------------------------")
    if all_layers_valid:
        print(f"  RESULT: Layer-by-layer embedding SUCCESSFUL for c = {c_val:.3f} ✅")
    else:
        print(f"  RESULT: Capacity bottleneck detected for c = {c_val:.3f} ❌")
    print("=========================================================================\n")
    return all_layers_valid

if __name__ == '__main__':
    for n in [4, 6, 8, 10]:
        analyze_layer_capacities(n, c_val=0.08)
