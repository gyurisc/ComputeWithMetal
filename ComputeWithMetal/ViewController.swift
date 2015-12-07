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
        // Do any additional setup after loading the view, typically from a nib.
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

