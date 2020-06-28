#
# Be sure to run `pod lib lint XLComProject.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XLComProject'
  s.version          = '0.1.3'
  s.summary          = 'iOS 工程通用基类库.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
DES OF 【iOS 工程通用基类库.】
                       DESC

  s.homepage         = 'https://github.com/GDXL2012/XLComProject'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GDXL2012' => 'liyijun_1989@163.com' }
  s.source           = { :git => 'https://github.com/GDXL2012/XLComProject.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'XLComProject/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XLComProject' => ['XLComProject/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.frameworks = 'AVFoundation', 'UIKit', 'Foundation', 'CoreGraphics', 'CoreServices', 'MessageUI'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'RegexKitLite'
  s.dependency 'SDWebImage'
  s.dependency 'SDWebImage/GIF'
  s.dependency 'MBProgressHUD'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'IQKeyboardManager'
  s.dependency 'Reachability', '~> 3.2'
  s.dependency 'IQKeyboardManager'
  s.dependency 'MJExtension'
end
