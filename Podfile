platform :ios, '17.0'
use_frameworks!

target 'Events' do
    pod 'SnapKit'
  pod 'Alamofire'
  pod 'SVProgressHUD'
end

# Setup target iOS version for all pods after install
post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
      end
  end
end
