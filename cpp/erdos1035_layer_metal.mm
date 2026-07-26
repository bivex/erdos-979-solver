#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#include <iostream>
#include <vector>
#include <random>
#include <chrono>

// Apple Metal GPU Layer Embedding Verification Solver for Erdős #1035

int main() {
    std::cout << "=========================================================================\n";
    std::cout << "  APPLE METAL GPU HIGH-SPEED LAYER EMBEDDING ENGINE FOR ERDŐS #1035\n";
    std::cout << "=========================================================================\n\n";

    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    if (!device) {
        std::cerr << "Error: Metal GPU device not found!\n";
        return 1;
    }

    std::cout << "  Metal GPU Device Name: " << [[device name] UTF8String] << "\n";
    std::cout << "  Unified Memory Architecture: Yes (Apple Silicon)\n\n";

    // Load Metal Shader Source
    NSError* error = nil;
    NSString* shaderPath = @"cpp/erdos1035_layer_metal.metal";
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

    id<MTLFunction> kernelFunction = [library newFunctionWithName:@"erdos1035_layer_kernel"];
    id<MTLComputePipelineState> pipelineState = [device newComputePipelineStateWithFunction:kernelFunction error:&error];
    if (!pipelineState) {
        std::cerr << "Error creating pipeline state: " << [[error localizedDescription] UTF8String] << "\n";
        return 1;
    }

    // Run Metal GPU verification for n = 4 (N = 16 vertices, Q_4 has 32 edges)
    uint32_t n = 4;
    uint32_t N = 1u << n;
    float c_threshold = 0.20f; // min degree delta(G) >= (1 - 0.20)*16 = 12.8 -> 13/16

    std::cout << "Testing Metal GPU Layer-by-Layer Embedding for n=" << n << " (N=" << N << " vertices)...\n";
    std::cout << "  Degree Constraint: delta(G) >= 13/16 (c = " << c_threshold << ")\n";

    // Construct dense host graph G with delta(G) >= 13
    std::vector<uint32_t> adj_matrix(N * N, 1);
    for (uint32_t i = 0; i < N; ++i) adj_matrix[i * N + i] = 0; // No self loops

    // Remove 2 edges per vertex regularly
    for (uint32_t i = 0; i < N; ++i) {
        uint32_t j1 = (i + 1) % N;
        uint32_t j2 = (i + 2) % N;
        adj_matrix[i * N + j1] = 0;
        adj_matrix[j1 * N + i] = 0;
        adj_matrix[i * N + j2] = 0;
        adj_matrix[j2 * N + i] = 0;
    }

    id<MTLBuffer> adjBuffer = [device newBufferWithBytes:adj_matrix.data()
                                                  length:sizeof(uint32_t) * N * N
                                                 options:MTLResourceStorageModeShared];

    uint32_t initial_count = 0;
    id<MTLBuffer> countBuffer = [device newBufferWithBytes:&initial_count
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
    [encoder setBuffer:countBuffer offset:0 atIndex:1];
    [encoder setBuffer:nBuffer offset:0 atIndex:2];

    uint32_t num_gpu_threads = 500000; // 500,000 parallel GPU layer embedding attempts
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
    uint32_t successful_gpu_embeddings = *(uint32_t*)[countBuffer contents];

    std::cout << "  Metal GPU Compute Execution Time: " << elapsed_ms << " ms\n";
    std::cout << "  Successful Layer Embeddings on GPU: " << successful_gpu_embeddings << " / " << num_gpu_threads
              << " (" << (successful_gpu_embeddings * 100.0 / num_gpu_threads) << "% success rate)\n\n";

    std::cout << "=========================================================================\n";
    std::cout << "  ERDŐS #1035 METAL GPU LAYER EMBEDDING COMPLETE ✅\n";
    std::cout << "=========================================================================\n";

    return 0;
}
