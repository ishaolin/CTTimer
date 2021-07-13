#
# Be sure to run `pod lib lint CTTimer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'CTTimer'
s.version          = '1.0'
s.summary          = 'A simple timer.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
The timer is safe, don't cause memory leaks.
DESC

s.homepage         = 'https://github.com/ishaolin/CTTimer'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'ishaolin' => 'ishaolin@163.com' }
s.source           = { :git => 'https://github.com/ishaolin/CTTimer.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.source_files = 'CTTimer/Classes/**/*'

end
