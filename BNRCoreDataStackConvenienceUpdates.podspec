#
# Be sure to run `pod lib lint BNRCoreDataStackConvenienceUpdates.podspec' to ensure this is a
# valid spec before submitting.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BNRCoreDataStackConvenienceUpdates"
  s.version          = "0.1.0"
  s.summary          = "BNRCoreDataStack ConvenienceUpdates Add On"
  s.description      = <<-DESC
                        BNRCoreDataStackConvenienceUpdates is an Add On to the BNRCoreDataStack library. 
                        It adds several methods to the CoreDataModelable protocol that makes creating new 
                        and updating existing managed objects easier.
                       DESC

  s.homepage         = "https://github.com/darrarski/BNRCoreDataStackConvenienceUpdates"
  s.license          = 'MIT'
  s.author           = { "Dariusz Rybicki" => "darrarski@gmail.com" }
  s.source           = { :git => "https://github.com/darrarski/BNRCoreDataStackConvenienceUpdates.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/darrarski'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/**/*'
  
  s.dependency 'BNRCoreDataStack', '~> 1.2'
end
