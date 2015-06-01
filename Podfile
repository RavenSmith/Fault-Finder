platform :ios, '7.0'

pod 'AFNetworking', '~>2.2.2'
#pod 'UIColorHelpers',  '~>1.0.0'
pod 'GoogleAnalytics-iOS-SDK', '~>3.0.6'
pod 'Bugsnag', '~>3.1.1'

post_install do |installer|
  require 'fileutils'
  FileUtils.copy('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'Settings.bundle/Acknowledgements.plist')
end