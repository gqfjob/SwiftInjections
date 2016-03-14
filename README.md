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

Definition of objects with scopes:

```
return self.define(withScope: .Singleton) { (definition) in


return self.define(withKey: "TheObject", scope: .Singleton) { (definition) in

```

## Keys

Due to lack of runtime features, object instances are stored inside assemblies object stack by `keys`. If key is not set it will use object type name as a key. It works until there's two or more objects with same type in one object graph

## How it works

Object is returned as result of `define` method of Assembly. This method checks scope. For `.Prototype` it calls injection block. For `.Singleton` and `.ObjectGraph` it checks current object graph stack if object instance exists using `key`. Existing instance returned as is. If object is not found in stack it calls injection block.

Injection block is called with `definition` object which holds object `key`, `scope` and `assembly` and redirects object init block into assembly's object instantiation method.

At the object instantiation method Assembly checks `scope` and `key` from definition. For `.Prototype` it just calls initBlock. For `.ObjectGraph` it checks current object graph stack if object instance exists using `key`. Existing instance returned as is. If object is not found in stack it calls injection block. For `.Singleton` it checks assembly singletons list if object instance exists using `key`. Existing instance returned as is. If object is not found in singletons list it calls injection block.

Circular dependencies resolved using objects stack and depth. Each call of `define` increments stack depth before call of injection block and decrements after it. If stack depth is zero after injection block call objects stack will be destroyed.

Definition of objects with keys:

```
return self.define(withKey: "TheObject") { (definition) in


return self.define(withKey: "TheObject", scope: .Singleton) { (definition) in

```

## Injections into existing objects

SwiftInjections can be used to inject data into existing objects. Also existing objects can be used to create circular dependencies. Injection into existing object should be a function with object as parameter. This object should be used inside init block instead of constructor.

Here's example:
```
public func injectIntoObject( inputObject:Object )->Object {
    return self.define() { (definition) in
        let object = definition *~> inputObject
        object.anotherObject = self.anotherObject
        return object
    }
}

public var anotherObject:AnotherObject {
    return self.define() { (definition) in
        let anotherObject = definition *~> AnotherObject()
        anotherObject.object = self.existingObjectByMatchingType()
        return anotherObject
    }
}
```
Method `existingObjectByMatchingType` returns object by Object Type as a Key for current Object Graph.
Also key can be set explicitly by means of `existingObject(withKey:)` method.

## Limitations

- needs key for creation of same type objects in single ObjectGraph
- assemblies are singletons with shared object graph and stack depth
- ugly syntax
- single-line object initialization blocks
- lazy singletons
- non-optional objects properties

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
