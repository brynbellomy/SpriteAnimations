Pod::Spec.new do |s|
  s.name = 'SpriteAnimations'
  s.version = '0.0.1'
  s.license = 'WTFPL'
  s.summary = 'Animation helper classes for SpriteKit (in Swift).'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }
  s.license = { :type => 'WTFPL', :file => 'LICENSE.md' }
  s.homepage = 'https://github.com/brynbellomy/SpriteAnimations'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'Classes/*.swift'
  s.requires_arc = true

  s.dependency 'Funky', '0.1.2'
  s.dependency 'SwiftLogger'
  s.dependency 'BrynSwift'
  s.dependency 'SwiftConfig'
  s.dependency 'LlamaKit'

  s.source = { :git => 'https://github.com/brynbellomy/SpriteAnimations.git', :tag => s.version }
end
