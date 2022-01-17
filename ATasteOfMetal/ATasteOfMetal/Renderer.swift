//
//  Renderer.swift
//  ATasteofMetal
//
//  Created by Cody Morley on 1/17/22.
//

import Metal
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    var vertexBuffer: MTLBuffer
    
    init?(mtkView: MTKView) {
        guard let deviceTemp = mtkView.device else {
            NSLog("Unable to initialize renderer. MTKView has no device or device is incompatible with Metal")
            return
        }
        device = deviceTemp
        
        guard let queue = device.makeCommandQueue() else {
            NSLog("Unable to initalize renderer. Bad or no CommandQueue object from MTKView")
            return
        }
        commandQueue = queue
        
        do {
            let stateTemp = try Renderer.buildRendererPipelineWith(device: device, metalKitView: mtkView)
            pipelineState = stateTemp
        } catch {
            NSLog("Unable to compile renderer pipeline state \n Error: \(error)")
            return nil
        }
        
        let vertices = [Vertex(color: [1, 0, 0, 1], pos: [-1, -1]),
                        Vertex(color: [1, 0, 0, 1], pos: [0, -1]),
                        Vertex(color: [1, 0, 0, 1], pos: [1, -1])]
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Vertex>.stride,
                                         options: [])!
        
                        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        <#code#>
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            NSLog("Command queue unable to intialize buffer.")
            return
        }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            NSLog("Failed to get current render pass descriptor.")
            return
        }
        
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.25, 1, 0.5, 1)
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            NSLog("Could not initialize render encoder from command buffer.")
            return
        }
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
    
    class func buildRendererPipelineWith(device: MTLDevice,
                                   metalKitView: MTKView) throws -> MTLRenderPipelineState {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = device.makeDefaultLibrary()
        
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
}
