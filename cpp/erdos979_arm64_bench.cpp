#include <iostream>
#include <vector>
#include <chrono>
#include <numeric>
#include <iomanip>
#include <cstdint>

// Assembly C declarations
extern "C" {
    void arm64_batch_add(const uint64_t* src_a, const uint64_t* src_b, uint64_t* dst, size_t count);
    void arm64_vector_sum_4(uint64_t base_q123, const uint64_t* q4_arr, uint64_t* out_arr, size_t count);
}

int main() {
    std::cout << "=========================================================================\n";
    std::cout << "  ARM64 NEON ASSEMBLY vs. C++17 SPEED BENCHMARK (APPLE SILICON)\n";
    std::cout << "=========================================================================\n\n";

    const size_t COUNT = 10'000'000; // 10 million elements
    std::vector<uint64_t> src_a(COUNT), src_b(COUNT), dst_cpp(COUNT), dst_arm(COUNT);

    for (size_t i = 0; i < COUNT; i++) {
        src_a[i] = i * 13 + 7;
        src_b[i] = i * 19 + 3;
    }

    uint64_t base_sum = 92797231684ULL;

    // 1. Standard C++ Loop
    auto t1 = std::chrono::high_resolution_clock::now();
    for (size_t i = 0; i < COUNT; i++) {
        dst_cpp[i] = base_sum + src_a[i];
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    double ms_cpp = std::chrono::duration<double, std::milli>(t2 - t1).count();

    // 2. ARM64 Assembly NEON Kernel
    t1 = std::chrono::high_resolution_clock::now();
    arm64_vector_sum_4(base_sum, src_a.data(), dst_arm.data(), COUNT);
    t2 = std::chrono::high_resolution_clock::now();
    double ms_arm = std::chrono::duration<double, std::milli>(t2 - t1).count();

    // Verification
    bool match = true;
    for (size_t i = 0; i < COUNT; i++) {
        if (dst_cpp[i] != dst_arm[i]) {
            match = false;
            break;
        }
    }

    std::cout << "Tested on " << COUNT << " 64-bit elements:\n";
    std::cout << "  Standard C++ Loop:      " << std::fixed << std::setprecision(2) << ms_cpp << " ms\n";
    std::cout << "  ARM64 NEON Assembly:    " << std::fixed << std::setprecision(2) << ms_arm << " ms\n";
    std::cout << "  Speedup Factor:         " << (ms_cpp / ms_arm) << "x faster\n";
    std::cout << "  Correctness Match:      " << (match ? "PASSED ✅" : "FAILED ❌") << "\n";
    std::cout << "=========================================================================\n";

    return 0;
}
