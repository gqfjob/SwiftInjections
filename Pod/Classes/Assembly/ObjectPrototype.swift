//
//  ObjectPrototype.swift
//  Pods
//
//  Created by Andrey Zarembo on 23.01.16.
//
//

import Foundation

public enum ObjectPrototype<ObjectType> {
    
    public typealias ObjectInitBlock = ()->ObjectType?
    public typealias ObjectInjectBlock = (object:ObjectType?)->ObjectType?
    
    case Definition(objectInitBlock:ObjectInitBlock,objectInjectBlock:ObjectInjectBlock)
    case Instance(object:ObjectType)
    
    public func instance()->ObjectType? {
        switch self {
        case let .Definition(objectInitBlock,objectInjectBlock):
            let object  = objectInitBlock()
            let injectedObject = objectInjectBlock(object:object)
            return injectedObject
        case let .Instance(object):
            return object
        }
    }
}