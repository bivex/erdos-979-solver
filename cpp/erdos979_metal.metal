#include <metal_stdlib>
using namespace metal;

kernel void erdos979_kernel(
    device const uint64_t* p4_array [[buffer(0)]],
    device uint64_t* result_quads [[buffer(1)]],
    device atomic_uint* match_count [[buffer(2)]],
    device const uint32_t* num_primes_ptr [[buffer(3)]],
    uint thread_idx [[thread_position_in_grid]]
) {
    uint num_primes = *num_primes_ptr;
    uint i = thread_idx;
    if (i >= num_primes) return;

    uint64_t p1_4 = p4_array[i];
    uint64_t target_n = 199898912404ULL;

    for (uint j = i; j < num_primes; ++j) {
        uint64_t p2_4 = p4_array[j];
        if (p1_4 + p2_4 >= target_n) break;

        for (uint k = j; k < num_primes; ++k) {
            uint64_t p3_4 = p4_array[k];
            if (p1_4 + p2_4 + p3_4 >= target_n) break;

            uint64_t p4_4 = target_n - (p1_4 + p2_4 + p3_4);

            // Binary search for p4_4 in p4_array starting at index k
            int low = k;
            int high = num_primes - 1;
            while (low <= high) {
                int mid = low + (high - low) / 2;
                uint64_t val = p4_array[mid];
                if (val == p4_4) {
                    uint slot = atomic_fetch_add_explicit(match_count, 1, memory_order_relaxed);
                    if (slot < 100) {
                        result_quads[slot * 4 + 0] = i;
                        result_quads[slot * 4 + 1] = j;
                        result_quads[slot * 4 + 2] = k;
                        result_quads[slot * 4 + 3] = (uint)mid;
                    }
                    break;
                } else if (val < p4_4) {
                    low = mid + 1;
                } else {
                    high = mid - 1;
                }
            }
        }
    }
}
