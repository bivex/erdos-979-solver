#include <iostream>
#include <vector>
#include <cmath>
#include <unordered_map>
#include <algorithm>
#include <iomanip>

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
    std::cout << "=========================================================================\n";
    std::cout << "  HIGH-PERFORMANCE C++17 SOLVER FOR ERDŐS PROBLEM #979\n";
    std::cout << "  f_k(n) = |{ (p_1, ..., p_k) : p_i are prime, n = p_1^k + ... + p_k^k }|\n";
    std::cout << "=========================================================================\n\n";

    // 1. k = 2 (Primes <= 2000)
    auto primes2 = getPrimes(2000);
    std::unordered_map<long long, int> counts2;
    for (size_t i = 0; i < primes2.size(); i++) {
        long long sq1 = primes2[i] * primes2[i];
        for (size_t j = i; j < primes2.size(); j++) {
            counts2[sq1 + primes2[j] * primes2[j]]++;
        }
    }
    int maxF2 = 0;
    long long maxN2 = 0;
    for (const auto& kv : counts2) {
        if (kv.second > maxF2) {
            maxF2 = kv.second;
            maxN2 = kv.first;
        }
    }
    std::cout << "[k = 2] Primes <= 2000 (" << primes2.size() << " primes):\n";
    std::cout << "  Max f_2(n) = " << maxF2 << " at n = " << maxN2 << "\n\n";

    // 2. k = 3 (Primes <= 400)
    auto primes3 = getPrimes(400);
    std::unordered_map<long long, int> counts3;
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
    std::unordered_map<int, int> freq3;
    for (const auto& kv : counts3) {
        freq3[kv.second]++;
        if (kv.second > maxF3) {
            maxF3 = kv.second;
            maxN3 = kv.first;
        }
    }
    std::cout << "[k = 3] Primes <= 400 (" << primes3.size() << " primes):\n";
    std::cout << "  Max f_3(n) = " << maxF3 << " at n = " << maxN3 << "\n";
    std::cout << "  Collisions: f_3(n)=3 (" << freq3[3] << " numbers), f_3(n)=2 (" << freq3[2] << " numbers)\n\n";

    // 3. k = 4 (Primes <= 150)
    auto primes4 = getPrimes(150);
    std::unordered_map<long long, int> counts4;
    for (size_t i = 0; i < primes4.size(); i++) {
        long long q1 = primes4[i] * primes4[i] * primes4[i] * primes4[i];
        for (size_t j = i; j < primes4.size(); j++) {
            long long q2 = q1 + primes4[j] * primes4[j] * primes4[j] * primes4[j];
            for (size_t m = j; m < primes4.size(); m++) {
                long long q3 = q2 + primes4[m] * primes4[m] * primes4[m] * primes4[m];
                for (size_t r = m; r < primes4.size(); r++) {
                    counts4[q3 + primes4[r] * primes4[r] * primes4[r] * primes4[r]]++;
                }
            }
        }
    }
    int maxF4 = 0;
    long long maxN4 = 0;
    std::unordered_map<int, int> freq4;
    for (const auto& kv : counts4) {
        freq4[kv.second]++;
        if (kv.second > maxF4) {
            maxF4 = kv.second;
            maxN4 = kv.first;
        }
    }
    std::cout << "[k = 4] Primes <= 150 (" << primes4.size() << " primes):\n";
    std::cout << "  Max f_4(n) = " << maxF4 << " at n = " << maxN4 << "\n";
    std::cout << "  Collisions: f_4(n)=3 (" << freq4[3] << " numbers), f_4(n)=2 (" << freq4[2] << " numbers)\n";
    std::cout << "=========================================================================\n";

    return 0;
}
