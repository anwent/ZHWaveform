ZHWaveform
----
ZHWaveform is a library written in Swift, you can easily draw an audio track on iOS, you can customize the slider on both sides, adjust the draw ratio, easy to use.


![005_none_ex](https://image.ibb.co/iY6f2G/005_none_ex.png)


![02_left_ex](https://image.ibb.co/gZieUw/02_left_ex.png)


![07_center_ex](https://image.ibb.co/dN3A2G/07_center_ex.png)

[中文文档](https://github.com/anwent/ZHWaveform/blob/master/README_CN.md)

Requirements
- - -
 - iOS 8.0+

 - Swift 4.0


Cocoapods
- - -
Add the following line to your `Podfile`:

`pod 'ZHWaveform', '~> 1.0.1'`
   
Then, run the following command:
 
`$ pod install`


Deserialization
 - - -
 
Import

`import ZHWaveform`

Create
 
     lazy var waveform: ZHWaveformView = {
        let bundle = Bundle(for: type(of: self)) // music
        let waveform = ZHWaveformView(
            frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 44),
            fileURL: bundle.url(forResource: "Apart", withExtension: "mp3")!
        )
        waveform.croppedDelegate = self
        return waveform
    }()
    
    
    
Setting

  wavesColor：`wavesColor: UIColor`
  

  Cut off the beginning part color：`beginningPartColor: UIColor`
  

  Cut out the end part color：`endPartColor: UIColor`
  
    
 Track Scale：`trackScale: CGFloat` (0 ~ 1)
 
 
 
Delegate
 
 Create start crop，Valid value is the `maxX` value of the view：
 
 `func waveformView(startCropped waveformView: ZHWaveformView) -> UIView?`
 
 
 Create end crop, Valid value is the `minX` value of the view:
 
 `func waveformView(endCropped waveformView: ZHWaveformView) -> UIView?`
 
 
 Start part of the crop current value:
 
 `func waveformView(startCropped: UIView, progress rate: CGFloat)`
 
 
 End part of the crop current value:
 
 `func waveformView(endCropped: UIView, progress rate: CGFloat)`
