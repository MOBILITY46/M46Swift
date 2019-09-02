#
# Be sure to run `pod lib lint M46Swift.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'M46Swift'
  s.version          = '1.2.1'
  s.summary          = 'iOS modules'
  s.description      = 'A collection of swift modules used my Mobility46'

  s.homepage         = 'https://github.com/MOBILITY46/M46Swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'David Jobe' => 'david.jobe@mobility46.se' }
  s.source           = { :git => 'https://github.com/MOBILITY46/M46Swift.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.source_files = 'M46Swift/Source/**/*'
end
