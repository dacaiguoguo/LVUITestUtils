
Pod::Spec.new do |s|
  s.name             = 'LVUITestUtilsServer'
  s.version          = '0.1.0'
  s.summary          = 'Take screenshots in Xcode UI Tests (Swift)'
  s.description      = <<-DESC
    Take screenshots in Xcode UI Tests (Swift), use Swifter for http server
                       DESC

  s.homepage         = 'https://github.com/dacaiguoguo/LVUITestUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunyanguo' => 'dacaiguoguo@163.com' }
  s.source           = { :git => 'https://github.com/dacaiguoguo/LVUITestUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LVUITestUtilsServer/Classes/**/*'
  s.dependency 'Swifter'
end
