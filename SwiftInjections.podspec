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
  s.summary          = "Simple dependency injection framework for Swift inspired by Typhoon."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
Syntax of object definition was made simple and easy to use. It differs from Typhoon's one, but has some look a like elements that makes learning easier.

```
public var object:TheObject {
return self.define() { (definition) in
let object1 = definition *~> Object1()
object1.object2 = self.assembly2.object2
return object1
}
}
```
Each injectable object is defined as computed property of Assembly. Object itself is created by call of assemblies method `define`, with object injection definition closure. Definition object should be used to initialize object with method `initObject` or by means of `*~>` operator to correctly resolve circular dependencies.
                       DESC

  s.homepage         = "https://gitlab.rambler.ru/cocoapods/SwiftInjections"
  s.license          = 'MIT'
  s.author           = { "Andrey Zarembo" => "a.zarembo-godzyatsky@rambler-co.ru" }
  s.source           = { :git => "https://gitlab.rambler.ru/cocoapods/SwiftInjections.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SwiftInjections' => ['Pod/Assets/*.png']
  }

  s.dependency 'SwiftDispatch', '~> 1.0'
end
