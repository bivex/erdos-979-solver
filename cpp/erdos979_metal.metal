#include <metal_stdlib>
using namespace metal;

kernel void erdos979_search_kernel(
    device const uint64_t* p4_array [[buffer(0)]],
    device uint64_t* landmark_results [[buffer(1)]],
    device atomic_uint* landmark_count [[buffer(2)]],
    device const uint32_t* num_primes_ptr [[buffer(3)]],
    uint thread_idx [[thread_position_in_grid]]
) {
    uint num_primes = *num_primes_ptr;
    uint i = thread_idx;
    if (i >= num_primes) return;

    uint64_t p1_4 = p4_array[i];

    for (uint j = i; j < num_primes; ++j) {
        uint64_t p2_4 = p4_array[j];
        uint64_t pair1 = p1_4 + p2_4;

        for (uint k = j; k < num_primes; ++k) {
            uint64_t p3_4 = p4_array[k];
            uint64_t triple = pair1 + p3_4;

            for (uint l = k; l < num_primes; ++l) {
                uint64_t sum = triple + p4_array[l];

                // Landmark check for 4-way collision candidates
                // We check if sum matches landmark residue n == 4 mod 240
                if (sum == 199898912404ULL || sum == 228696341524ULL || 
                    sum == 318417970324ULL || sum == 955118369284ULL ||
                    sum == 1215633611284ULL || sum == 7431769413844ULL) {
                    
                    uint slot = atomic_fetch_add_explicit(landmark_count, 1, memory_order_relaxed);
                    if (slot < 100) {
                        landmark_results[slot * 5 + 0] = sum;
                        landmark_results[slot * 5 + 1] = i;
                        landmark_results[slot * 5 + 2] = j;
                        landmark_results[slot * 5 + 3] = k;
                        landmark_results[slot * 5 + 4] = l;
                    }
                }
            }
        }
    }
}
