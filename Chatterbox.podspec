Pod::Spec.new do |s|
  s.name             = 'Chatterbox'
  s.version          = '0.2.0'
  s.summary          = 'Plug and play chat library for iOS'
  s.description      = <<-DESC
Plug and play chat library for iOS
                       DESC

  s.homepage         = 'https://github.com/Hipo/chatterbox-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hipo' => 'hello@hipolabs.com' }
  s.source           = { :git => 'https://github.com/Hipo/chatterbox-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hipolabs'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Chatterbox/Classes/*.swift'

  s.dependency 'IGListKit'
  s.dependency 'SocketRocket'
  s.dependency 'SnapKit', '~> 4.0'
end
