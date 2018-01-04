//
//  ZHCroppedDelegate.swift
//  ZHWaveform_Example
//
//  Created by wow250250 on 2018/1/2.
//  Copyright © 2018年 wow250250. All rights reserved.
//

import UIKit

@objc public protocol ZHCroppedDelegate {
    
    /**
     value view's maxX
     */
    func waveformView(startCropped waveformView: ZHWaveformView) -> UIView?
    
    /**
     value view's minX
     */
    func waveformView(endCropped waveformView: ZHWaveformView) -> UIView?
    
    /**
     start cropped
     */
    func waveformView(startCropped: UIView, progress rate: CGFloat)
    
    /**
     end cropped
     */
    func waveformView(endCropped: UIView, progress rate: CGFloat)
    
    /**
     will
     */
    @objc optional func waveformView(croppedStartDragging cropped: UIView)
    
    /**
     ing
     */
    @objc optional func waveformView(croppedDragIn cropped: UIView)
    
    /**
     ed
     */
    @objc optional func waveformView(croppedDragFinish cropped: UIView)
    
}
