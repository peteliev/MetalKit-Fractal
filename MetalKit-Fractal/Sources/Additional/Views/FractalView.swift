//
//  FractalView.swift
//  MetalKit-Fractal
//
//  Created by Zhenya Peteliev on 25.11.2019.
//  Copyright © 2019 Yevhenii Peteliev. All rights reserved.
//

import Cocoa
import MetalKit

final class FractalView: MTKView {
    
    // MARK: - Initializers
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        device = MTLCreateSystemDefaultDevice()
        commonInit()
    }
    
    private func commonInit() {
        framebufferOnly = false

        guard let device = device else { return }
        commandQueue = device.makeCommandQueue()
        
        createBuffers()
        registerShaders()
    }
    
    // MARK: - NSView
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard
            let drawable = currentDrawable,
            let commandQueue = commandQueue,
            let computePipelineState = computePipelineState,
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let commandEncoder = commandBuffer.makeComputeCommandEncoder() else { return }
        
        commandEncoder.setComputePipelineState(computePipelineState)
        commandEncoder.setTexture(drawable.texture, index: 0)
        commandEncoder.setBuffer(timerBuffer, offset: 0, index: 1)
        update()
        
        let threadGroupCount = MTLSizeMake(8, 8, 1)
        let threadGroups = MTLSizeMake(drawable.texture.width / threadGroupCount.width, drawable.texture.height / threadGroupCount.height, 1)
        commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
        commandEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    // MARK: - Private Properies
    private var timer: Float = 0
    private var timerBuffer: MTLBuffer? = nil
    
    private var commandQueue: MTLCommandQueue? = nil
    private var computePipelineState: MTLComputePipelineState? = nil
}

// MARK: - Setup Methods
private extension FractalView {
    
    func createBuffers() {
        guard let device = device else { return }
        timerBuffer = device.makeBuffer(length: MemoryLayout<Float>.size, options: [])
    }
    
    func registerShaders() {
        guard
            let device = device,
            let library = device.makeDefaultLibrary(),
            let kernel = library.makeFunction(name: "computeFractal"),
            let computePipelineState = try? device.makeComputePipelineState(function: kernel) else { return }
                
        self.computePipelineState = computePipelineState
    }
}

// MARK: - Update Methods
private extension FractalView {
    
    func update() {
        guard let timerBuffer = timerBuffer else { return }
        
        let bufferPointer = timerBuffer.contents()
        memcpy(bufferPointer, &timer, MemoryLayout<Float>.size)
        
        timer += 0.01
    }
}
