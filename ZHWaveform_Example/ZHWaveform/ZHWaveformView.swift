//
//  ZHWaveformView.swift
//  ZHWaveform_Example
//
//  Created by wow250250 on 2018/1/2.
//  Copyright © 2018年 wow250250. All rights reserved.
//

import UIKit
import AVFoundation

class ZHWaveformView: UIView {
    
    /** waves color */
    open var wavesColor: UIColor = .red {
        didSet {
            DispatchQueue.main.async {
                _ = self.trackLayer.map({ [unowned self] in
                    $0.strokeColor = self.wavesColor.cgColor
                })
            }
        }
    }
    
    /** Cut off the beginning part color */
    open var beginningPartColor: UIColor = .gray
    
    /** Cut out the end part color */
    open var endPartColor: UIColor = .gray
    
    /** Track Scale normal 0.5, max 1*/
    open var trackScale: CGFloat = 0.5 {
        didSet {
            if let `assetMutableData` = assetMutableData {
                croppedViewZero()
                trackProcessingCut = ZHTrackProcessing.cutAudioData(size: self.frame.size, recorder: assetMutableData, scale: trackScale)
                drawTrack(
                    with: CGRect(x: (startCroppedView?.bounds.width ?? 0),
                                 y: 0,
                                 width: self.frame.width - (startCroppedView?.bounds.width ?? 0) - (endCroppedView?.bounds.width ?? 0),
                                 height: self.frame.height),
                    filerSamples: trackProcessingCut ?? []
                )
            }
        }
    }
    
    open weak var croppedDelegate: ZHCroppedDelegate? {
        didSet { layoutIfNeeded() }
    }
    
    open weak var waveformDelegate: ZHWaveformViewDelegate?
    
    private var fileURL: URL
    
    private var asset: AVAsset?
    
    private var track: AVAssetTrack?
    
    private var trackLayer: [CAShapeLayer] = []
    
    private var startCroppedView: UIView?
    
    private var endCroppedView: UIView?
    
    private var leftCorppedCurrentX: CGFloat = 0
    
    private var rightCorppedCurrentX: CGFloat = 0
    
    private var trackWidth: CGFloat = 0
    
    private var startCorppedIndex: Int = 0
    
    private var endCorppedIndex: Int = 0
    
    private var trackProcessingCut: [CGFloat]?
    
    private var assetMutableData: NSMutableData?
    
    init(frame: CGRect, fileURL: URL) {
        self.fileURL = fileURL
        super.init(frame: frame)
        waveformDelegate?.waveformViewStartDrawing?(waveformView: self)
        backgroundColor = .white
        asset = AVAsset(url: fileURL)
        track = asset?.tracks(withMediaType: .audio).first
        
        ZHAudioProcessing.bufferRef(asset: asset!, track: track!, success: { [unowned self] (data) in
            self.assetMutableData = data
            self.trackProcessingCut = ZHTrackProcessing.cutAudioData(size: frame.size, recorder: data, scale: self.trackScale)
            self.drawTrack(with: CGRect(origin: .zero, size: frame.size), filerSamples: self.trackProcessingCut ?? [])
            self.waveformDelegate?.waveformViewDrawComplete?(waveformView: self)
        }) { (error) in
            assert(true, error?.localizedDescription ?? "Error, AudioProcessing.bufferRef")
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        if let samples = trackProcessingCut {
            creatCroppedView()
            drawTrack(
                with: CGRect(x: startCroppedView?.bounds.width ?? 0,
                             y: 0,
                             width: frame.width - (startCroppedView?.bounds.width ?? 0) - (endCroppedView?.bounds.width ?? 0),
                             height: frame.height),
                filerSamples: samples
            )
        }
    }
    
    func drawTrack(with rect: CGRect, filerSamples: [CGFloat]) {
        _ = trackLayer.map{ $0.removeFromSuperlayer() }
        trackLayer.removeAll()
        startCroppedView?.removeFromSuperview()
        endCroppedView?.removeFromSuperview()
        // bezier width
        trackWidth = rect.width / (CGFloat(filerSamples.count - 1) + CGFloat(filerSamples.count))
        endCorppedIndex = filerSamples.count
        for t in 0..<filerSamples.count {
            let layer = CAShapeLayer()
            layer.frame = CGRect(
                x: CGFloat(t) * trackWidth * 2 + (startCroppedView?.bounds.width ?? 0),
                y: 0,
                width: trackWidth,
                height: rect.height
            )
            layer.lineCap = kCALineCapButt
            layer.lineJoin = kCALineJoinRound
            layer.lineWidth = trackWidth
            layer.strokeColor = wavesColor.cgColor
            self.layer.addSublayer(layer)
            self.trackLayer.append(layer)
        }
        
        for i in 0..<filerSamples.count {
            let itemLinePath = UIBezierPath()
            let y: CGFloat = (rect.height - filerSamples[i]) / 2
            let height: CGFloat = filerSamples[i] + y
            itemLinePath.move(to: CGPoint(x: 0, y: y))
            itemLinePath.addLine(to: CGPoint(x: 0, y: height))
            itemLinePath.close()
            itemLinePath.lineWidth = trackWidth
            let itemLayer = trackLayer[i]
            itemLayer.path = itemLinePath.cgPath
        }
        if let l = startCroppedView {
            addSubview(l)
        }
        if let r = endCroppedView {
            addSubview(r)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZHWaveformView {
    
    private func croppedViewZero() {
        if let leftCropped = startCroppedView {
            leftCropped.frame = CGRect(x: 0, y: leftCropped.frame.origin.y, width: leftCropped.bounds.width, height: leftCropped.bounds.height)
        }
        if let rightCropped = endCroppedView {
            rightCropped.frame = CGRect(x: bounds.width - rightCropped.bounds.width, y: rightCropped.frame.origin.y, width: rightCropped.bounds.width, height: rightCropped.bounds.height)
        }
        
    }
    
    private func creatCroppedView() {
        if let leftCropped = croppedDelegate?.waveformView(startCropped: self) {
            leftCropped.frame = CGRect(x: 0, y: leftCropped.frame.origin.y, width: leftCropped.bounds.width, height: leftCropped.bounds.height)
            leftCorppedCurrentX = 0
            let leftPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.leftCroppedPanRecognizer(sender:)))
            leftCropped.addGestureRecognizer(leftPanRecognizer)
            leftCropped.isUserInteractionEnabled = true
            startCroppedView = leftCropped
        }
        
        if let rightCropped = croppedDelegate?.waveformView(endCropped: self) {
            rightCropped.frame = CGRect(x: bounds.width - rightCropped.bounds.width, y: rightCropped.frame.origin.y, width: rightCropped.bounds.width, height: rightCropped.bounds.height)
            rightCorppedCurrentX = bounds.width - rightCropped.bounds.width
            let rightPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.rightCroppedPanRecognizer(sender:)))
            rightCropped.addGestureRecognizer(rightPanRecognizer)
            rightCropped.isUserInteractionEnabled = true
            endCroppedView = rightCropped
        }
    }
    
    @objc private func leftCroppedPanRecognizer(sender: UIPanGestureRecognizer) {
        let limitMinX: CGFloat = frame.minX
        let limitMaxX: CGFloat = endCroppedView?.frame.minX ?? bounds.width
        if sender.state == .began {
            croppedDelegate?.waveformView?(croppedDragIn: startCroppedView ?? UIView())
        } else if sender.state == .changed {
            croppedDelegate?.waveformView?(croppedDragIn: startCroppedView ?? UIView())
            let newPoint = sender.translation(in: self)
            var center = startCroppedView?.center
            center?.x = leftCorppedCurrentX + newPoint.x
            guard (center?.x ?? 0) > limitMinX && (center?.x ?? 0) < limitMaxX else { return }
            startCroppedView?.center = center ?? .zero
        } else if sender.state == .ended || sender.state == .failed {
            croppedDelegate?.waveformView?(croppedDragFinish: startCroppedView ?? UIView())
            leftCorppedCurrentX = startCroppedView?.center.x ?? 0
        }
        if (startCroppedView?.frame.minX ?? 0) < 0 {
            var leftFrame = startCroppedView?.frame
            leftFrame?.origin.x = 0
            startCroppedView?.frame = leftFrame ?? .zero
        }
        
        if (startCroppedView?.frame.maxX ?? 0) > limitMaxX {
            var leftFrame = startCroppedView?.frame
            leftFrame?.origin.x = limitMaxX - (startCroppedView?.bounds.width ?? 0)
            startCroppedView?.frame = leftFrame ?? .zero
        } // floorf ceilf
        let lenght = ceilf(Float((((startCroppedView?.frame.maxX ?? 0) - (startCroppedView?.bounds.width ?? 0)) / trackWidth)))
        let bzrLenght = ceilf(lenght/2)
        startCorppedIndex = Int(bzrLenght) > trackLayer.count ? trackLayer.count : Int(bzrLenght)
        self.croppedWaveform(start: startCorppedIndex, end: endCorppedIndex)
        let bezierWidth = self.frame.width - (startCroppedView?.frame.width ?? 0) - (endCroppedView?.frame.width ?? 0)
        croppedDelegate?.waveformView(startCropped: startCroppedView ?? UIView(), progress: ((startCroppedView?.frame.maxX ?? 0) - 20)/bezierWidth)
    }
    
    @objc private func rightCroppedPanRecognizer(sender: UIPanGestureRecognizer) {
        let limitMinX: CGFloat = startCroppedView?.frame.maxX ?? 0
        let limitMaxX: CGFloat = frame.maxX
        if sender.state == .began {
            croppedDelegate?.waveformView?(croppedStartDragging: endCroppedView ?? UIView())
        } else if sender.state == .changed {
            croppedDelegate?.waveformView?(croppedDragIn: endCroppedView ?? UIView())
            let newPoint = sender.translation(in: self)
            var center = endCroppedView?.center
            center?.x = rightCorppedCurrentX + newPoint.x
            guard (center?.x ?? 0) > limitMinX && (center?.x ?? 0) < limitMaxX else { return }
            endCroppedView?.center = center ?? .zero
        } else if sender.state == .ended || sender.state == .failed {
            croppedDelegate?.waveformView?(croppedDragFinish: endCroppedView ?? UIView())
            rightCorppedCurrentX = endCroppedView?.center.x ?? (bounds.width - (endCroppedView?.bounds.width ?? 0))
        }
        if (endCroppedView?.frame.maxX ?? 0) > frame.maxX {
            var rightFrame = endCroppedView?.frame
            rightFrame?.origin.x = frame.maxX - (endCroppedView?.bounds.width ?? 0)
            endCroppedView?.frame = rightFrame ?? .zero
        }
        if (endCroppedView?.frame.minX ?? 0) < limitMinX {
            var rightFrame = endCroppedView?.frame
            rightFrame?.origin.x = limitMinX
            endCroppedView?.frame = rightFrame ?? .zero
        }
        let lenght = ceilf(Float(((endCroppedView?.frame.minX ?? 0) - (startCroppedView?.bounds.width ?? 0)) / trackWidth))
        let bzrLenght = floorf(lenght/2) < 0 ? 0 : ceilf(lenght/2)
        endCorppedIndex = Int(bzrLenght)
        self.croppedWaveform(start: startCorppedIndex, end: endCorppedIndex)
        let bezierWidth = self.frame.width - (startCroppedView?.frame.width ?? 0) - (endCroppedView?.frame.width ?? 0)
        croppedDelegate?.waveformView(endCropped: endCroppedView ?? UIView(), progress: ((endCroppedView?.frame.minX ?? 0)-20)/bezierWidth)
    }
    
    typealias TrackIndex = Int
    public func croppedWaveform(
        start: TrackIndex,
        end: TrackIndex
        ) {
        let beginLayers = trackLayer[0..<start]
        let wavesLayers = trackLayer[start..<end]
        let endLayers = trackLayer[end..<trackLayer.count]
        DispatchQueue.main.async {
            _ = beginLayers.map({ [unowned self] in
                $0.strokeColor = self.beginningPartColor.cgColor
            })
            _ = wavesLayers.map({ [unowned self] in
                $0.strokeColor = self.wavesColor.cgColor
            })
            _ = endLayers.map({ [unowned self] in
                $0.strokeColor = self.endPartColor.cgColor
            })
        }
    }
    
}
