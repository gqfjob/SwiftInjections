//
//  AssemblyResolver.swift
//  Pods
//
//  Created by Andrey Zarembo on 22.01.16.
//
//

import Foundation

public class AssemblyResolver<AssemblyClass:AssemblyProtocol>: ObjectInjector {
    public func instance()->AssemblyClass {
        let instance:AssemblyClass = AssemblyClass.instance()
        return instance
    }
    
    public init() {}
    
    public func inject<ObjectType>(intoObject object:ObjectType, injectionBlock:(ObjectType)->ObjectType) -> ObjectType {
        return self.instance().inject(intoObject: object, injectionBlock: injectionBlock)
    }
    
    public func instantiate<ObjectType>(withScope scope:ObjectScope, injectionBlock:(ObjectType)->ObjectType) -> ObjectType {
        return self.instance().instantiate(withScope: scope, injectionBlock: injectionBlock)
    }
    
    public func object<ObjectType>(fromDefinition definition:Definition<ObjectType>) -> ObjectType {
        return self.instance().object(fromDefinition: definition)
    }
}