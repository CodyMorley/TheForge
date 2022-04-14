//
//  ViewController.swift
//  Breakout
//
//  Created by Cody Morley on 4/7/22.
//

import UIKit
import MetalKit


class ViewController: UIViewController {
    //MARK: - Properties -
    // Place for device and command queue that make up command buffer.
    var renderer: MetalRenderer!
    // Wires into storyboard view
    var metalView: MTKView { return view as! MTKView }
    
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        guard let newDevice = MTLCreateSystemDefaultDevice() else {
            NSLog("Could not get system device")
            return
        }
        super.viewDidLoad()
        renderer = MetalRenderer(device: newDevice)
        metalView.device = renderer.device
        metalView.delegate = renderer
        metalView.clearColor = Colors.wGreen
    }
}
