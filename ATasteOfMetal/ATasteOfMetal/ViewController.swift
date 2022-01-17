//
//  ViewController.swift
//  ATasteofMetal
//
//  Created by Cody Morley on 1/17/22.
//

import Cocoa
import Metal
import MetalKit

class ViewController: NSViewController {
    
    var mtkView: MTKView!
    var renderer: Renderer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mtkViewTemp = self.view as? MTKView else {
            NSLog("View Attached to View Controller does not conform to type MTKView.")
            return
        }
        mtkView = mtkViewTemp
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            NSLog("Metal framework is unsupported on device type.")
            return
        }
        NSLog("Deafault device to be set as \(defaultDevice)")
        mtkView.device = defaultDevice
        
        guard let rendererTemp = Renderer(mtkView: mtkView) else {
            NSLog("Unable to initialize renderer object with given MTKView")
            return
        }
        renderer = rendererTemp
        mtkView.delegate = renderer
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

