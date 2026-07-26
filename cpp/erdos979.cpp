#include <iostream>
#include <vector>
#include <cmath>
#include <unordered_map>
#include <algorithm>
#include <iomanip>
#include <chrono>
#include <map>
#include <thread>
#include <mutex>

// Helper to check primality
bool isPrime(long long n) {
    if (n < 2) return false;
    if (n == 2 || n == 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (long long i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
}

// Generate primes up to limit
std::vector<long long> getPrimes(long long limit) {
    std::vector<long long> primes;
    for (long long i = 2; i <= limit; i++) {
        if (isPrime(i)) primes.push_back(i);
    }
    return primes;
}

int main() {
    auto t_start = std::chrono::high_resolution_clock::now();

    std::cout << "=========================================================================\n";
    std::cout << "  ADVANCED MULTI-THREADED C++17 SOLVER FOR ERDŐS PROBLEM #979\n";
    std::cout << "  f_k(n) = |{ (p_1, ..., p_k) : p_i prime, n = p_1^k + ... + p_k^k }|\n";
    std::cout << "=========================================================================\n\n";

    // 1. k = 2 (Primes <= 3000)
    auto t1 = std::chrono::high_resolution_clock::now();
    auto primes2 = getPrimes(3000);
    std::unordered_map<long long, int> counts2;
    counts2.reserve(primes2.size() * primes2.size() / 2);

    for (size_t i = 0; i < primes2.size(); i++) {
        long long sq1 = primes2[i] * primes2[i];
        for (size_t j = i; j < primes2.size(); j++) {
            counts2[sq1 + primes2[j] * primes2[j]]++;
        }
    }

    int maxF2 = 0;
    long long maxN2 = 0;
    std::map<int, int> freq2;
    for (const auto& kv : counts2) {
        freq2[kv.second]++;
        if (kv.second > maxF2) {
            maxF2 = kv.second;
            maxN2 = kv.first;
        }
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    double ms2 = std::chrono::duration<double, std::milli>(t2 - t1).count();

    std::cout << "[k = 2] Primes <= 3000 (" << primes2.size() << " primes) [" << std::fixed << std::setprecision(1) << ms2 << " ms]:\n";
    std::cout << "  Record: Max f_2(n) = " << maxF2 << " at n = " << maxN2 << "\n\n";

    // 2. k = 3 (Primes <= 1000)
    t1 = std::chrono::high_resolution_clock::now();
    auto primes3 = getPrimes(1000);
    std::unordered_map<long long, int> counts3;
    counts3.reserve(primes3.size() * primes3.size() * primes3.size() / 6);

    for (size_t i = 0; i < primes3.size(); i++) {
        long long cb1 = primes3[i] * primes3[i] * primes3[i];
        for (size_t j = i; j < primes3.size(); j++) {
            long long cb2 = cb1 + primes3[j] * primes3[j] * primes3[j];
            for (size_t m = j; m < primes3.size(); m++) {
                counts3[cb2 + primes3[m] * primes3[m] * primes3[m]]++;
            }
        }
    }

    int maxF3 = 0;
    long long maxN3 = 0;
    std::map<int, int> freq3;
    for (const auto& kv : counts3) {
        freq3[kv.second]++;
        if (kv.second > maxF3) {
            maxF3 = kv.second;
            maxN3 = kv.first;
        }
    }
    t2 = std::chrono::high_resolution_clock::now();
    double ms3 = std::chrono::duration<double, std::milli>(t2 - t1).count();

    std::cout << "[k = 3] Primes <= 1000 (" << primes3.size() << " primes) [" << ms3 << " ms]:\n";
    std::cout << "  Record: Max f_3(n) = " << maxF3 << " at n = " << maxN3 << "\n\n";

    // 3. k = 4 (Primes <= 400) - Multi-threaded
    t1 = std::chrono::high_resolution_clock::now();
    auto primes4 = getPrimes(400);
    std::vector<long long> q4;
    for (auto p : primes4) q4.push_back(p * p * p * p);

    std::unordered_map<long long, int> counts4;
    counts4.reserve(primes4.size() * primes4.size() * primes4.size() * primes4.size() / 24);

    unsigned int numThreads = std::thread::hardware_concurrency();
    if (numThreads == 0) numThreads = 4;

    std::vector<std::thread> threads;
    std::vector<std::unordered_map<long long, int>> localCounts(numThreads);

    size_t totalI = primes4.size();
    for (unsigned int t = 0; t < numThreads; t++) {
        threads.emplace_back([t, numThreads, totalI, &q4, &localCounts]() {
            for (size_t i = t; i < totalI; i += numThreads) {
                long long q1 = q4[i];
                for (size_t j = i; j < totalI; j++) {
                    long long q12 = q1 + q4[j];
                    for (size_t m = j; m < totalI; m++) {
                        long long q123 = q12 + q4[m];
                        for (size_t r = m; r < totalI; r++) {
                            localCounts[t][q123 + q4[r]]++;
                        }
                    }
                }
            }
        });
    }

    for (auto& th : threads) th.join();

    for (unsigned int t = 0; t < numThreads; t++) {
        for (const auto& kv : localCounts[t]) {
            counts4[kv.first] += kv.second;
        }
    }

    int maxF4 = 0;
    long long maxN4 = 0;
    std::map<int, int> freq4;
    for (const auto& kv : counts4) {
        freq4[kv.second]++;
        if (kv.second > maxF4) {
            maxF4 = kv.second;
            maxN4 = kv.first;
        }
    }
    t2 = std::chrono::high_resolution_clock::now();
    double ms4 = std::chrono::duration<double, std::milli>(t2 - t1).count();

    std::cout << "[k = 4] Primes <= 400 (" << primes4.size() << " primes, " << numThreads << " threads) [" << ms4 << " ms]:\n";
    std::cout << "  Record: Max f_4(n) = " << maxF4 << " at n = " << maxN4 << "\n";
    std::cout << "=========================================================================\n";

    auto t_end = std::chrono::high_resolution_clock::now();
    double total_ms = std::chrono::duration<double, std::milli>(t_end - t_start).count();
    std::cout << "Total execution time: " << total_ms / 1000.0 << " seconds.\n";
    std::cout << "=========================================================================\n";

    return 0;
}




