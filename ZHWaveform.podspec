#
#  Be sure to run `pod spec lint ZHWaveform.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZHWaveform"
  s.version      = "1.0.1"
  s.summary      = "Quickly draw audio volume tracks on iOS, which implement by Swift"

  s.description  = <<-DESC
  Easy to draw audio music tracks, you can drag the slider to select the time
                   DESC

  s.homepage     = "https://github.com/anwent/ZHWaveform"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author       = { "zzh" => "wow250250@163.com" }

  s.source       = { :git => "https://github.com/anwent/ZHWaveform.git", :tag => "1.0.1" }

  s.source_files  = "ZHWaveform_Example/ZHWaveform/*.{swift}" 
  s.requires_arc  = true
  s.platform      = :ios, '8.0'
  s.framework     = 'Foundation', 'AVFoundation', 'UIKit' 

end
