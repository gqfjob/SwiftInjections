//
//  Definition.swift
//  Pods
//
//  Created by Andrey Zarembo on 24.01.16.
//
//

import Foundation

public enum Scope {
    case ObjectGraph
    case Prototype
    case Singleton
    case WeakSingleton
}

public class AnyObjectDefinition: Hashable {
    public var uuid:NSUUID
    
    public init() {
        self.uuid = NSUUID()
    }
    
    public var hashValue:Int {
        get {
            return self.uuid.hashValue
        }
    }
}

public class Definition<ObjectType>: AnyObjectDefinition {
    
    public typealias ObjectInitBlock = ()->ObjectType
    public typealias ObjectInjectBlock = (object:ObjectType)->ObjectType
    
    var scope:Scope
    var objectInitBlock:ObjectInitBlock
    var objectInjectBlock:ObjectInjectBlock
    
    public init(withScope scope:Scope, objectInitBlock: ObjectInitBlock, objectInjectBlock: ObjectInjectBlock) {
        self.scope = scope
        self.objectInitBlock = objectInitBlock
        self.objectInjectBlock = objectInjectBlock
        super.init()
    }
}

public func == (left:AnyObjectDefinition, right:AnyObjectDefinition) -> Bool {
    return left.uuid == right.uuid
}

public struct ObjectModel<ObjectType> {
    typealias ObjectModelBlock = ()->ObjectType
    
    var objectModelBlock:ObjectModelBlock
    
    init(objectModelBlock:ObjectModelBlock) {
        self.objectModelBlock = objectModelBlock
    }
}