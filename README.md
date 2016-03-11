# SwiftInjections

Simple dependency injection framework for Swift inspired by Typhoon. It uses assemblies as object factories which perform injections and object configurations. 

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

## Scopes

Object initialization scope can be defined as `Singleton`, `ObjectGraph` or `Prototype`. 

* **Singleton** - this is Lazy singleton. It's created at first property access. For such object definition closure is called only once.

* **ObjectGraph** - this scope creates one object copy per object graph. Resolves circular dependencies, but can create retain cycles.

* **Prototype** - this scope creates one copy of object at every property request. Circular dependecies of prototypes leads to infinite cycle.

## Keys

Due to lack of runtime features, object instances are stored inside assemblies object stack by `keys`. If key is not set it will use object type name as a key. It works until there's two or more objects with same type 

## How it works

Object is returned as result of `define` method of Assembly. This method checks order of object ca

## Usage

To run the tests project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftInjections is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftInjections"
```

## Author

Andrey Zarembo, a.zarembo-godzyatsky@rambler-co.ru

## License

SwiftInjections is available under the MIT license. See the LICENSE file for more info.
