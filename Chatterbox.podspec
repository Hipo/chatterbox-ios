Pod::Spec.new do |s|
  s.name             = 'Chatterbox'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Chatterbox.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Hakan Demiröz/Chatterbox'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hakan Demiröz' => 'mhdemiroz@gmail.com' }
  s.source           = { :git => 'https://github.com/Hakan Demiröz/Chatterbox.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Chatterbox/Classes/*.swift'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'IGListKit', '~> 3.0'
  s.dependency 'SocketRocket'
  s.dependency 'SnapKit', '~> 3.0'
end
