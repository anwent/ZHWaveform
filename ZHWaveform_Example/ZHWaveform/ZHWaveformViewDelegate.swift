//
//  ZHWaveformViewDelegate.swift
//  ZHWaveform_Example
//
//  Created by wow250250 on 2018/1/2.
//  Copyright © 2018年 wow250250. All rights reserved.
//

import UIKit

@objc public protocol ZHWaveformViewDelegate {
    
    // start
    @objc optional func waveformViewStartDrawing(waveformView: ZHWaveformView)
    
    // complete
    @objc optional func waveformViewDrawComplete(waveformView: ZHWaveformView)
    
}
