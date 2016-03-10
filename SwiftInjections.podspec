#
# Be sure to run `pod lib lint SwiftInjections.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftInjections"
  s.version          = "2.0.0"
  s.summary          = "Легкий аналог Typhoon для Swift, чтобы не сильно переучиваться."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://gitlab.rambler.ru/cocoapods/SwiftInjections"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Andrey Zarembo" => "a.zarembo-godzyatsky@rambler-co.ru" }
  s.source           = { :git => "https://gitlab.rambler.ru/cocoapods/SwiftInjections.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SwiftInjections' => ['Pod/Assets/*.png']
  }

  s.dependency 'SwiftDispatch', '~> 1.0'
end
