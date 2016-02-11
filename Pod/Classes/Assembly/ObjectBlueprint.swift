//
//  ObjectBlueprint.swift
//  Pods
//
//  Created by Andrey Zarembo on 26.01.16.
//
//

import Foundation

public class ObjectBlueprint<ObjectType> {
    
    public typealias ObjectBuildBlockType = (definition:Definition<ObjectType>)->ObjectType
    
    public var objectBuildBlock:ObjectBuildBlockType
    public var definition:Definition<ObjectType>
    
    public init(withBuildBlock block:ObjectBuildBlockType, definition: Definition<ObjectType>) {
        self.objectBuildBlock = block
        self.definition = definition
    }
    
    public var instance:ObjectType {
        get {
            return self.objectBuildBlock(definition: self.definition)
        }
    }
}