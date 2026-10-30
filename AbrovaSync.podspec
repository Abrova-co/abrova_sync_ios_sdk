Pod::Spec.new do |s|
  s.name             = 'AbrovaSync'
  s.version          = '0.3.0'
  s.summary          = 'Realtime database SDK for iOS with offline-first sync'
  s.description      = 'Realtime database SDK for iOS with offline-first sync'
  s.homepage         = 'https://abrova.ir'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Abrova' => 'support@abrova.ir' }
  s.source           = { :git => 'https://github.com/Abrova-co/abrova_sync_ios_sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.7'

  s.source_files = 'Sources/**/*.swift'

  s.dependency 'PNProtocol', '~> 0.2'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
