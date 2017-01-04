#
# Be sure to run `pod lib lint LVUITestUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LVUITestUtils'
  s.version          = '0.1.0'
  s.summary          = 'LVUITestUtils extend Xcode 7 UI Testing framework (XCTest).'

  s.description      = <<-DESC
LVUITestUtils extend Xcode 7 UI Testing framework (XCTest).
saveScreenshot ok
                       DESC

  s.homepage         = 'https://github.com/dacaiguoguo/LVUITestUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunyanguo' => 'dacaiguoguo@163.com' }
  s.source           = { :git => 'https://github.com/dacaiguoguo/LVUITestUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LVUITestUtils/Classes/**/*'
  
  s.frameworks = 'UIKit', 'XCTest'
  s.dependency 'SimulatorStatusMagic'
end
