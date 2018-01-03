//
//  ViewController.swift
//  ZHWaveform_Example
//
//  Created by wow250250 on 2018/1/2.
//  Copyright © 2018年 wow250250. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ZHCroppedDelegate, ZHWaveformViewDelegate {
    
    lazy var waveform: ZHWaveformView = {
        let thisBundle = Bundle(for: type(of: self))
        let waveform = ZHWaveformView(
            frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 44),
            fileURL: thisBundle.url(forResource: "Apart", withExtension: "mp3")!
        )
        
        // color
        waveform.beginningPartColor = .gray
        waveform.endPartColor = .gray
        waveform.wavesColor = .orange
        
        // 0 ~ 1
        waveform.trackScale = 0.3
        
        waveform.waveformDelegate = self
        waveform.croppedDelegate = self

        return waveform
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(waveform)
    }
    
    
    func waveformView(startCropped waveformView: ZHWaveformView) -> UIView? {
        let start = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        start.backgroundColor = .red
        return start
    }

    func waveformView(endCropped waveformView: ZHWaveformView) -> UIView? {
        let end = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        end.backgroundColor = .blue
        return end
    }

    func waveformView(startCropped: UIView, progress rate: CGFloat) {
        print("Left rate:", rate)
    }

    func waveformView(endCropped: UIView, progress rate: CGFloat) {
        print("Right rate:", rate)
    }
    
    // ...
    
}


