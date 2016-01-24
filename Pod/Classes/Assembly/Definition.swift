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
    case LazySingleton
    case WealSingleton
}

public class Definition<ObjectType> {
    
    public typealias ObjectInitBlock = ()->ObjectType
    public typealias ObjectInjectBlock = (object:ObjectType)->ObjectType
    
    var scope:Scope
    var objectInitBlock:ObjectInitBlock
    var objectInjectBlock:ObjectInjectBlock
    
    public init(withScope scope:Scope, objectInitBlock: ObjectInitBlock, objectInjectBlock: ObjectInjectBlock) {
        self.scope = scope
        self.objectInitBlock = objectInitBlock
        self.objectInjectBlock = objectInjectBlock
    }
}