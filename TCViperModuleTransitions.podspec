#
# Be sure to run `pod lib lint TCViperModuleTransitions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TCViperModuleTransitions"
  s.version          = "0.1.0"
  s.summary          = "TCViperModuleTransitions is a set of classes for implementing VIPER module transitions in iOS application."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = "TCViperModuleTransitions is a set of classes for implementing VIPER module transitions in iOS application."

  s.homepage         = "https://github.com/Tayphoon/ViperModuleTransitions"
  s.license          = 'MIT'
  s.author           = { "Tayphoon" => "tayphoon.company@gmail.com" }
  s.source           = { :git => "https://github.com/Tayphoon/ViperModuleTransitions.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

### Subspecs

  s.default_subspecs = 'Core'

  s.subspec 'Core' do |core|
    core.public_header_files = 'TCViperModuleTransitions/TCViperModuleTransitions.h', 'TCViperModuleTransitions/*.{h}'
    core.source_files = 'TCViperModuleTransitions/*.{h,m}'

  end

end
