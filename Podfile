# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'Makgulli' do
  pod 'NMapsMap'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.5'
      end
    end
  end
  # Pods for Makgull

  target 'MakgulliTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MakgulliUITests' do
    # Pods for testing
  end

end
