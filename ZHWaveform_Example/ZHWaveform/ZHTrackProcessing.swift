//
//  ZHTrackProcessing.swift
//  ZHWaveform_Example
//
//  Created by wow250250 on 2018/1/2.
//  Copyright © 2018年 wow250250. All rights reserved.
//

import UIKit
import AVFoundation

struct ZHTrackProcessing {
    public static func cutAudioData(size: CGSize, recorder data: NSMutableData, scale: CGFloat) -> [CGFloat] {
        var filteredSamplesMA: [CGFloat] = []
        let sampleCount = data.length / MemoryLayout<Int>.size
        let binSize = CGFloat(sampleCount) / (size.width * scale)
        var i = 0
        while i < sampleCount {
            let rangeData = data.subdata(with: NSRange(location: i, length: 1))
            let item = rangeData.withUnsafeBytes({ (ptr: UnsafePointer<Int>) -> Int in
                return ptr.pointee
            })
            filteredSamplesMA.append(CGFloat(item))
            i += Int(binSize)
        }
        return trackScale(size: size, source: filteredSamplesMA)
    }
    
    private static func trackScale(size: CGSize, source: [CGFloat]) -> [CGFloat] {
        if let max = source.max() {
            let k = size.height / max
            return source.map{ $0 * k }
        }
        return source
    }
}
