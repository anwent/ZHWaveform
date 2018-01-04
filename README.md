#ZHWaveform
----
ZHWaveform是一个用Swift编写的库，可以轻松的在iOS 上绘制出音频音轨，可自定义两侧滑块，调整绘制比例，使用方便。


![005_none_ex](https://image.ibb.co/iY6f2G/005_none_ex.png)


![02_left_ex](https://image.ibb.co/gZieUw/02_left_ex.png)


![07_center_ex](https://image.ibb.co/dN3A2G/07_center_ex.png)


###要求
- - -
 - iOS 8.0+

 - Swift 4.0

- - -
###Cocoapods
    
`pod 'ZHWaveform', '~> 1.0.1'`
   
然后运行以下命令
 
`$ pod install`

###示例代码
 - - -
 
####导入
`import ZHWaveform`
####创建
 
     lazy var waveform: ZHWaveformView = {
        let bundle = Bundle(for: type(of: self)) // music
        let waveform = ZHWaveformView(
            frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 44),
            fileURL: bundle.url(forResource: "Apart", withExtension: "mp3")!
        )
        waveform.croppedDelegate = self
        return waveform
    }()
    
    
    
####设定

  音轨颜色：`wavesColor: UIColor`

  拖动后左侧颜色：`beginningPartColor: UIColor`

  拖动后右侧颜色：`endPartColor: UIColor`
    
 缩放比例：`trackScale: CGFloat` (0~1)
 
 
####Delegate
 
 创建左侧滑块，有效值view的maxX：
 `func waveformView(startCropped waveformView: ZHWaveformView) -> UIView?`
 
 创建右侧滑块，有效值view的minX
 `func waveformView(endCropped waveformView: ZHWaveformView) -> UIView?`
 
 左滑块当前值:
 `func waveformView(startCropped: UIView, progress rate: CGFloat)`
 
 右滑块当前值:
 `func waveformView(endCropped: UIView, progress rate: CGFloat)`
