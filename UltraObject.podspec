#
# Be sure to run `pod lib lint UltraObject.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "UltraObject"
  s.version          = "0.1.2"
  s.summary          = "Ultra Object is event based model framework."
  s.description      = <<-DESC
                       Ultra Object is event based model framework. It helps you to manage
                       objects easily. Especially if you're using RESTful api, this can be
                       a good solution for creating, updating and destroying objects while
                       applying the changes to views and controllers.

                       Ultra Object also helps you to apply mutable/immutable pattern.
                       DESC
  s.homepage         = "https://github.com/ssowonny/UltraObject"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Sungwon Lee" => "ssowonny@gmail.com" }
  s.source           = { :git => "https://github.com/ssowonny/UltraObject.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'UltraObject' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'JSONModel', '~> 1.1.0'
end
