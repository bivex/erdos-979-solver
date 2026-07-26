// ============================================================================
//  ARM64 High-Performance Assembly Engine for Erdős Problem #979
//  Target Architecture: Apple Silicon ARM64 (M1/M2/M3/M4) / macOS AAPCS64
// ============================================================================

.global _arm64_batch_add
.global _arm64_vector_sum_4
.align 4

// ----------------------------------------------------------------------------
// Function: _arm64_batch_add
// Description: Vectorized addition of two uint64_t arrays using NEON 128-bit registers.
// C Signature: void arm64_batch_add(const uint64_t* src_a, const uint64_t* src_b, uint64_t* dst, size_t count)
// Parameters:
//   x0: src_a (pointer to first 64-bit array)
//   x1: src_b (pointer to second 64-bit array)
//   x2: dst   (pointer to destination array)
//   x3: count (number of uint64_t elements)
// ----------------------------------------------------------------------------
_arm64_batch_add:
    // Check if count == 0
    cbz     x3, .Ladd_done

    // Process 4 elements (2 NEON registers = 256 bits) per iteration
.Ladd_loop_4x:
    cmp     x3, #4
    b.lt    .Ladd_remainder

    // Load 4 uint64_t elements into v0 (2d) and v1 (2d)
    ldp     q0, q1, [x0], #32
    ldp     q2, q3, [x1], #32

    // Vector addition 64-bit x 2
    add     v4.2d, v0.2d, v2.2d
    add     v5.2d, v1.2d, v3.2d

    // Store 4 uint64_t elements to destination
    stp     q4, q5, [x2], #32

    sub     x3, x3, #4
    b       .Ladd_loop_4x

.Ladd_remainder:
    cbz     x3, .Ladd_done

.Ladd_single:
    ldr     x4, [x0], #8
    ldr     x5, [x1], #8
    add     x6, x4, x5
    str     x6, [x2], #8
    subs    x3, x3, #1
    b.ne    .Ladd_single

.Ladd_done:
    ret

// ----------------------------------------------------------------------------
// Function: _arm64_vector_sum_4
// Description: NEON SIMD core for computing sum = base_q123 + q4[r] for a batch.
// C Signature: void arm64_vector_sum_4(uint64_t base_q123, const uint64_t* q4_arr, uint64_t* out_arr, size_t count)
// Parameters:
//   x0: base_q123 (64-bit sum of first 3 prime powers)
//   x1: q4_arr    (pointer to array of 4th prime powers)
//   x2: out_arr   (pointer to output destination)
//   x3: count     (number of elements)
// ----------------------------------------------------------------------------
_arm64_vector_sum_4:
    cbz     x3, .Lsum4_done

    // Duplicate base_q123 across NEON vector v0.2d
    dup     v0.2d, x0

.Lsum4_loop:
    cmp     x3, #4
    b.lt    .Lsum4_remainder

    // Load 4 64-bit elements from q4_arr
    ldp     q1, q2, [x1], #32

    // Add base sum to all elements in parallel
    add     v3.2d, v1.2d, v0.2d
    add     v4.2d, v2.2d, v0.2d

    // Store results
    stp     q3, q4, [x2], #32

    sub     x3, x3, #4
    b       .Lsum4_loop

.Lsum4_remainder:
    cbz     x3, .Lsum4_done

.Lsum4_single:
    ldr     x4, [x1], #8
    add     x5, x4, x0
    str     x5, [x2], #8
    subs    x3, x3, #1
    b.ne    .Lsum4_single

.Lsum4_done:
    ret
