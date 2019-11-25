//
//  ViewController.swift
//  MetalKit-Fractal
//
//  Created by Zhenya Peteliev on 25.11.2019.
//  Copyright © 2019 Yevhenii Peteliev. All rights reserved.
//

import Cocoa

final class ViewController: NSViewController {
    
    // MARK: - Outlwts
    @IBOutlet private weak var fractalView: FractalView!

    // MARK: - NSViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    @IBAction func sliderDidChangeValue(_ slider: NSSlider) {
        fractalView.innerColorOffset = slider.floatValue
    }
}

// MARK: - Setup Methods
private extension ViewController {
    
    func setupViewController() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
    }
}

