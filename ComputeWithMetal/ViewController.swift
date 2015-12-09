//
//  ViewController.swift
//  ComputeWithMetal
//
//  Created by Krisztian Gyuris on 07/12/15.
//  Copyright © 2015 Krisztian Gyuris. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

     override func viewDidLoad() {
        super.viewDidLoad()
        
        // Input data 
        var myVector = [Float](count:123456, repeatedValue: 0);
        
        // Output data 
        var resultData = [Float](count:123456, repeatedValue: 0);
        
        for (index, _) in myVector.enumerate() {
            myVector[index] = Float(index)
        }
        
        // Initialize Metal 
        var (device, commandQueue, defaultLibrary, commandBuffer, computeCommandEncoder) = initMetal()
        
        // Setting up a compute pipeline with Sigmoid function and add it to encoder 
        let sigmoidProgram = defaultLibrary.newFunctionWithName("sigmoid")
        
     
        do
        {
            var computePipelineFilter = try device.newComputePipelineStateWithFunction(sigmoidProgram!)
            computeCommandEncoder.setComputePipelineState(computePipelineFilter)
        } catch _ {
            print("Failed to create pipeline")
        }
        
        // Create GPU input and output data
        var myVectorByteLength = myVector.count*sizeofValue(myVector[0])
        
        // in-buffer
        var inVectorBuffer = device.newBufferWithBytes(&myVector, length: myVectorByteLength, options: MTLResourceOptions.CPUCacheModeDefaultCache)
        computeCommandEncoder.setBuffer(inVectorBuffer, offset: 0, atIndex: 0)
        
        // out-buffer
        var outVectorBuffer = device.newBufferWithBytes(&resultData, length: myVectorByteLength, options: MTLResourceOptions.CPUCacheModeDefaultCache)
        computeCommandEncoder.setBuffer(outVectorBuffer, offset: 0, atIndex: 1)
        
        // Configure GPU Threads
        // hardcoded to 32 for now (recommendation: read about threadExecutionWidth)
        var threadsPerGroup = MTLSize(width:32,height:1,depth:1)
        var numThreadgroups = MTLSize(width:(myVector.count+31)/32, height:1, depth:1)
        computeCommandEncoder.dispatchThreadgroups(numThreadgroups, threadsPerThreadgroup: threadsPerGroup)
        
        // Start processing 
        computeCommandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        // Get result data out from GPU 
        var data = NSData(bytesNoCopy: outVectorBuffer.contents(), length: myVector.count*sizeof(Float), freeWhenDone: false)
        var finalResultArray = [Float](count: myVector.count, repeatedValue: 0)
        data.getBytes(&finalResultArray, length:myVector.count * sizeof(Float))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func initMetal() -> (MTLDevice, MTLCommandQueue, MTLLibrary, MTLCommandBuffer, MTLComputeCommandEncoder) {
        
        // GPU device
        let device = MTLCreateSystemDefaultDevice()
        
        // Ordered list of command buffers
        let commandQueue = device!.newCommandQueue()
        
        // Metal functions stored in .metal files
        var defaultLibrary = device!.newDefaultLibrary()
        
        // Buffer for storing encoded commands 
        var commandBuffer = commandQueue.commandBuffer()
        
        // Encoder for GPU commands 
        var computeCommandEncoder = commandBuffer.computeCommandEncoder()
        
        return (device!, commandQueue, defaultLibrary!, commandBuffer, computeCommandEncoder)
    }
}

