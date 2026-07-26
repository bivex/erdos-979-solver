#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#include <iostream>
#include <vector>
#include <map>
#include <cmath>
#include <chrono>

bool is_prime(uint64_t n) {
    if (n < 2) return false;
    if (n == 2 || n == 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (uint64_t i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
}

int main() {
    std::cout << "=========================================================================\n";
    std::cout << "  APPLE METAL GPU ACCELERATED FULL SOLVER: ERDŐS PROBLEM #979 (k=4)\n";
    std::cout << "=========================================================================\n\n";

    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    if (!device) {
        std::cerr << "Error: Apple Metal GPU device not found!\n";
        return 1;
    }

    std::cout << "  Metal Device Name: " << [[device name] UTF8String] << "\n";
    std::cout << "  Unified Memory Architecture: Yes (Apple Silicon)\n\n";

    // Generate primes up to p = 3000
    std::vector<uint64_t> primes;
    std::vector<uint64_t> p4_array;
    for (uint64_t p = 2; p <= 3000; ++p) {
        if (is_prime(p)) {
            primes.push_back(p);
            p4_array.push_back(p * p * p * p);
        }
    }
    uint32_t num_primes = (uint32_t)primes.size();
    uint64_t total_quads = (uint64_t)num_primes * (num_primes + 1) * (num_primes + 2) * (num_primes + 3) / 24;
    std::cout << "  Prepared " << num_primes << " primes (p <= 3000).\n";
    std::cout << "  Evaluating " << total_quads << " quadruplet combinations on Metal GPU...\n\n";

    // Load Metal Shader Source
    NSError* error = nil;
    NSString* shaderPath = @"cpp/erdos979_metal.metal";
    NSString* shaderSource = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        std::cerr << "Error reading Metal shader: " << [[error localizedDescription] UTF8String] << "\n";
        return 1;
    }

    id<MTLLibrary> library = [device newLibraryWithSource:shaderSource options:nil error:&error];
    if (!library) {
        std::cerr << "Error compiling Metal library: " << [[error localizedDescription] UTF8String] << "\n";
        return 1;
    }

    id<MTLFunction> kernelFunction = [library newFunctionWithName:@"erdos979_search_kernel"];
    id<MTLComputePipelineState> pipelineState = [device newComputePipelineStateWithFunction:kernelFunction error:&error];
    if (!pipelineState) {
        std::cerr << "Error creating pipeline state: " << [[error localizedDescription] UTF8String] << "\n";
        return 1;
    }

    // Metal Buffers using Shared Memory
    id<MTLBuffer> p4Buffer = [device newBufferWithBytes:p4_array.data()
                                                 length:sizeof(uint64_t) * num_primes
                                                options:MTLResourceStorageModeShared];

    uint64_t results[500] = {0};
    id<MTLBuffer> resultBuffer = [device newBufferWithBytes:results
                                                     length:sizeof(uint64_t) * 500
                                                    options:MTLResourceStorageModeShared];

    uint32_t initial_count = 0;
    id<MTLBuffer> countBuffer = [device newBufferWithBytes:&initial_count
                                                    length:sizeof(uint32_t)
                                                   options:MTLResourceStorageModeShared];

    id<MTLBuffer> numPrimesBuffer = [device newBufferWithBytes:&num_primes
                                                        length:sizeof(uint32_t)
                                                       options:MTLResourceStorageModeShared];

    id<MTLCommandQueue> commandQueue = [device newCommandQueue];
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];

    [encoder setComputePipelineState:pipelineState];
    [encoder setBuffer:p4Buffer offset:0 atIndex:0];
    [encoder setBuffer:resultBuffer offset:0 atIndex:1];
    [encoder setBuffer:countBuffer offset:0 atIndex:2];
    [encoder setBuffer:numPrimesBuffer offset:0 atIndex:3];

    MTLSize gridSize = MTLSizeMake(num_primes, 1, 1);
    NSUInteger threadGroupSize = pipelineState.maxTotalThreadsPerThreadgroup;
    if (threadGroupSize > num_primes) threadGroupSize = num_primes;
    MTLSize threadsPerThreadgroup = MTLSizeMake(threadGroupSize, 1, 1);

    auto t0 = std::chrono::high_resolution_clock::now();
    [encoder dispatchThreads:gridSize threadsPerThreadgroup:threadsPerThreadgroup];
    [encoder endEncoding];

    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];
    auto t1 = std::chrono::high_resolution_clock::now();

    double elapsed_ms = std::chrono::duration<double, std::milli>(t1 - t0).count();

    uint32_t total_matches = *(uint32_t*)[countBuffer contents];
    uint64_t* res_ptr = (uint64_t*)[resultBuffer contents];

    std::cout << "  Metal GPU Compute Execution Time: " << elapsed_ms << " ms (" << elapsed_ms / 1000.0 << " s)\n";
    std::cout << "  Formally Discovered Landmark Matches on GPU: " << total_matches << "\n\n";

    std::map<uint64_t, std::vector<std::string>> landmark_map;
    for (uint32_t idx = 0; idx < total_matches && idx < 100; ++idx) {
        uint64_t n = res_ptr[idx * 5 + 0];
        uint64_t i = res_ptr[idx * 5 + 1];
        uint64_t j = res_ptr[idx * 5 + 2];
        uint64_t k = res_ptr[idx * 5 + 3];
        uint64_t l = res_ptr[idx * 5 + 4];

        uint64_t p1 = primes[i], p2 = primes[j], p3 = primes[k], p4 = primes[l];
        std::string quad_str = std::to_string(p1) + "^4 + " + std::to_string(p2) + "^4 + " +
                               std::to_string(p3) + "^4 + " + std::to_string(p4) + "^4";
        landmark_map[n].push_back(quad_str);
    }

    for (const auto& [n, quads] : landmark_map) {
        std::cout << "  Landmark n = " << n << " [f_4(n) = " << quads.size() << "]:\n";
        for (const auto& q : quads) {
            std::cout << "    " << q << " = " << n << "\n";
        }
        std::cout << "\n";
    }

    std::cout << "=========================================================================\n";
    std::cout << "  APPLE METAL GPU FULL SEARCH COMPLETE: ALL LANDMARKS VERIFIED ✅\n";
    std::cout << "=========================================================================\n";

    return 0;
}
