//
//  Shaders.metal
//  ComputeWithMetal
//
//  Created by Krisztian Gyuris on 07/12/15.
//  Copyright © 2015 Krisztian Gyuris. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


kernel void sigmoid(const device float *inVector [[ buffer(0)]],
                    device float *outVector [[ buffer(1)]],
                    uint id [[ thread_position_in_grid]]) {
    // Sigmoid function on GPU
    outVector[id] = 1.0 / (1.0 + exp(-inVector[id]));
}

