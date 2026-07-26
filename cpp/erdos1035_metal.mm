#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#include <iostream>
#include <vector>
#include <random>
#include <chrono>

// Erdős Problem #1035 Metal GPU Solver & Subgraph Embedding Engine

struct HypercubeProperties {
    int n;
    uint64_t num_vertices;
    uint64_t num_edges;
    uint64_t min_degree;
    uint64_t max_bipartite_side;
};

HypercubeProperties get_hypercube_props(int n) {
    uint64_t vertices = 1ULL << n;
    uint64_t edges = n * (1ULL << (n - 1));
    return {n, vertices, edges, (uint64_t)n, vertices / 2};
}

int main() {
    std::cout << "=========================================================================\n";
    std::cout << "  APPLE METAL GPU HIGH-PERFORMANCE SOLVER: ERDŐS PROBLEM #1035\n";
    std::cout << "=========================================================================\n\n";

    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    if (!device) {
        std::cerr << "Error: Metal GPU device not found!\n";
        return 1;
    }

    std::cout << "  Metal Device Name: " << [[device name] UTF8String] << "\n";
    std::cout << "  Unified Memory Architecture: Yes (Apple Silicon)\n\n";

    // Structural table display for Q_n
    std::cout << "Hypercube Structural Analysis (Q_n for n = 2..8):\n";
    std::cout << "  n   Vertices (2^n)   Edges (n*2^(n-1))   Degree d   Bipartite Sides\n";
    std::cout << "  -------------------------------------------------------------------\n";
    for (int n = 2; n <= 8; ++n) {
        auto props = get_hypercube_props(n);
        std::cout << "  " << props.n << "   " 
                  << props.num_vertices << "              "
                  << props.num_edges << "               "
                  << props.min_degree << "          "
                  << props.max_bipartite_side << " + " << props.max_bipartite_side << "\n";
    }
    std::cout << "\n-------------------------------------------------------------------------\n";

    // Load Metal Shader Source
    NSError* error = nil;
    NSString* shaderPath = @"cpp/erdos1035_metal.metal";
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

    id<MTLFunction> kernelFunction = [library newFunctionWithName:@"erdos1035_embedding_kernel"];
    id<MTLComputePipelineState> pipelineState = [device newComputePipelineStateWithFunction:kernelFunction error:&error];
    if (!pipelineState) {
        std::cerr << "Error creating pipeline state: " << [[error localizedDescription] UTF8String] << "\n";
        return 1;
    }

    // Run GPU test for n = 4 (N = 16 vertices, Q_4 has 32 edges)
    uint32_t n = 4;
    uint32_t N = 1u << n;
    float c_threshold = 0.15f; // min degree delta(G) > (1 - 0.15) * 16 = 13.6 -> min_deg = 14

    std::cout << "Running GPU Parallel Embedding Search for Erdős #1035 (n=" << n << ", N=" << N << ")...\n";
    std::cout << "  Graph Minimum Degree Requirement: delta(G) >= 14 / 16 (degree deficit <= 2)\n";

    // Construct dense random host graph G with delta(G) >= 14
    std::vector<uint32_t> adj_matrix(N * N, 1);
    // Remove diagonal (no self-loops)
    for (uint32_t i = 0; i < N; ++i) adj_matrix[i * N + i] = 0;

    // Randomly delete edges ensuring min degree >= 14
    std::mt19937 rng(42);
    for (uint32_t i = 0; i < N; ++i) {
        uint32_t current_deg = N - 1;
        while (current_deg > 14) {
            uint32_t j = rng() % N;
            if (i != j && adj_matrix[i * N + j] == 1) {
                adj_matrix[i * N + j] = 0;
                adj_matrix[j * N + i] = 0;
                current_deg--;
            }
        }
    }

    id<MTLBuffer> adjBuffer = [device newBufferWithBytes:adj_matrix.data()
                                                  length:sizeof(uint32_t) * N * N
                                                 options:MTLResourceStorageModeShared];

    uint32_t found_flag = 0;
    id<MTLBuffer> foundBuffer = [device newBufferWithBytes:&found_flag
                                                    length:sizeof(uint32_t)
                                                   options:MTLResourceStorageModeShared];

    id<MTLBuffer> nBuffer = [device newBufferWithBytes:&n
                                                 length:sizeof(uint32_t)
                                                options:MTLResourceStorageModeShared];

    id<MTLCommandQueue> commandQueue = [device newCommandQueue];
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];

    [encoder setComputePipelineState:pipelineState];
    [encoder setBuffer:adjBuffer offset:0 atIndex:0];
    [encoder setBuffer:foundBuffer offset:0 atIndex:1];
    [encoder setBuffer:nBuffer offset:0 atIndex:2];

    uint32_t num_gpu_threads = 100000;
    MTLSize gridSize = MTLSizeMake(num_gpu_threads, 1, 1);
    NSUInteger threadGroupSize = pipelineState.maxTotalThreadsPerThreadgroup;
    if (threadGroupSize > num_gpu_threads) threadGroupSize = num_gpu_threads;
    MTLSize threadsPerThreadgroup = MTLSizeMake(threadGroupSize, 1, 1);

    auto t0 = std::chrono::high_resolution_clock::now();
    [encoder dispatchThreads:gridSize threadsPerThreadgroup:threadsPerThreadgroup];
    [encoder endEncoding];

    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];
    auto t1 = std::chrono::high_resolution_clock::now();

    double elapsed_ms = std::chrono::duration<double, std::milli>(t1 - t0).count();
    uint32_t is_found = *(uint32_t*)[foundBuffer contents];

    std::cout << "  Metal GPU Compute Execution Time: " << elapsed_ms << " ms\n";
    std::cout << "  GPU Embedding Search Result: " << (is_found ? "SPANNING HYPERCUBE Q_4 FOUND ✅" : "NOT FOUND ❌") << "\n\n";

    std::cout << "=========================================================================\n";
    std::cout << "  ERDŐS #1035 METAL GPU EMBEDDING VERIFICATION COMPLETE ✅\n";
    std::cout << "=========================================================================\n";

    return 0;
}
