//
//  ViewController.swift
//  MetalKit-Fractal
//
//  Created by Zhenya Peteliev on 25.11.2019.
//  Copyright © 2019 Yevhenii Peteliev. All rights reserved.
//

import Cocoa

final class ViewController: NSViewController {

    // MARK: - NSViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

// MARK: - Setup Methods
private extension ViewController {
    
    func setupViewController() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
    }
}

