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

// Primality check
bool isPrime(long long n) {
    if (n < 2) return false;
    if (n == 2 || n == 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (long long i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
}

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
    std::cout << "  TARGETED SEARCH FOR RECORD f_3(n) >= 5 AND f_3(n) >= 6 (CUBIC PRIMES)\n";
    std::cout << "=========================================================================\n\n";

    long long PRIME_LIMIT = 6000;
    auto primes3 = getPrimes(PRIME_LIMIT);
    size_t P = primes3.size();

    std::cout << "Searching k = 3 with primes <= " << PRIME_LIMIT << " (" << P << " primes)...\n";
    std::vector<long long> cb3;
    for (auto p : primes3) cb3.push_back(p * p * p);

    unsigned long long totalTriplets = P * (P + 1) * (P + 2) / 6;
    std::cout << "Total triplets (p1^3 + p2^3 + p3^3) to evaluate: " << totalTriplets << "\n";

    unsigned int numThreads = std::thread::hardware_concurrency();
    if (numThreads == 0) numThreads = 8;
    std::cout << "Utilizing " << numThreads << " parallel CPU threads.\n\n";

    std::vector<std::thread> threads;
    std::vector<std::unordered_map<long long, int>> localCounts(numThreads);

    auto t1 = std::chrono::high_resolution_clock::now();

    for (unsigned int t = 0; t < numThreads; t++) {
        threads.emplace_back([t, numThreads, P, totalTriplets, &cb3, &localCounts]() {
            localCounts[t].reserve(totalTriplets / numThreads);
            for (size_t i = t; i < P; i += numThreads) {
                long long c1 = cb3[i];
                for (size_t j = i; j < P; j++) {
                    long long c12 = c1 + cb3[j];
                    for (size_t m = j; m < P; m++) {
                        localCounts[t][c12 + cb3[m]]++;
                    }
                }
            }
        });
    }

    for (auto& th : threads) th.join();

    auto t2 = std::chrono::high_resolution_clock::now();
    double ms_eval = std::chrono::duration<double, std::milli>(t2 - t1).count();
    std::cout << "Evaluation completed in " << std::fixed << std::setprecision(1) << ms_eval << " ms. Merging threads...\n";

    std::unordered_map<long long, int> globalCounts;
    globalCounts.reserve(totalTriplets);

    for (unsigned int t = 0; t < numThreads; t++) {
        for (const auto& kv : localCounts[t]) {
            globalCounts[kv.first] += kv.second;
        }
    }

    int maxF3 = 0;
    long long maxN3 = 0;
    std::map<int, int> freq3;
    std::vector<long long> recordCandidates5;
    std::vector<long long> recordCandidates6;

    for (const auto& kv : globalCounts) {
        freq3[kv.second]++;
        if (kv.second > maxF3) {
            maxF3 = kv.second;
            maxN3 = kv.first;
        }
        if (kv.second == 5) recordCandidates5.push_back(kv.first);
        if (kv.second >= 6) recordCandidates6.push_back(kv.first);
    }

    std::cout << "\n=========================================================================\n";
    std::cout << "  RESULTS FOR k = 3 (Primes <= " << PRIME_LIMIT << "):\n";
    std::cout << "  MAXIMUM COLLISION COUNT: f_3(n) = " << maxF3 << "\n";
    std::cout << "  RECORD NUMBER: n = " << maxN3 << "\n\n";

    std::cout << "  Distribution of f_3(n):\n";
    for (const auto& kv : freq3) {
        if (kv.first >= 3) {
            std::cout << "    f_3(n) = " << kv.first << ": " << kv.second << " numbers\n";
        }
    }

    if (!recordCandidates5.empty()) {
        std::cout << "\n  🏆 NUMBERS WITH f_3(n) = 5 (" << recordCandidates5.size() << " found):\n";
        for (auto n : recordCandidates5) {
            std::cout << "  --- n = " << n << " (f_3 = 5, n mod 9 = " << n % 9 << ", n mod 7 = " << n % 7 << ") ---\n";
            for (size_t i = 0; i < P; i++) {
                for (size_t j = i; j < P; j++) {
                    for (size_t m = j; m < P; m++) {
                        if (cb3[i] + cb3[j] + cb3[m] == n) {
                            std::cout << "    " << primes3[i] << "^3 + " << primes3[j] << "^3 + " << primes3[m] << "^3 = " << n << "\n";
                        }
                    }
                }
            }
        }
    }

    if (!recordCandidates6.empty()) {
        std::cout << "\n  🎉🎉 WORLD RECORD BREAKTHROUGH: NUMBERS WITH f_3(n) >= 6 (" << recordCandidates6.size() << " found):\n";
        for (auto n : recordCandidates6) {
            std::cout << "  --- n = " << n << " (f_3 = " << globalCounts[n] << ") ---\n";
            for (size_t i = 0; i < P; i++) {
                for (size_t j = i; j < P; j++) {
                    for (size_t m = j; m < P; m++) {
                        if (cb3[i] + cb3[j] + cb3[m] == n) {
                            std::cout << "    " << primes3[i] << "^3 + " << primes3[j] << "^3 + " << primes3[m] << "^3 = " << n << "\n";
                        }
                    }
                }
            }
        }
    } else {
        std::cout << "\n  ℹ️ No number with f_3(n) >= 6 found up to prime limit " << PRIME_LIMIT << ".\n";
    }

    std::cout << "=========================================================================\n";
    auto t_end = std::chrono::high_resolution_clock::now();
    double total_ms = std::chrono::duration<double, std::milli>(t_end - t_start).count();
    std::cout << "Total execution time: " << total_ms / 1000.0 << " seconds.\n";
    std::cout << "=========================================================================\n";

    return 0;
}
