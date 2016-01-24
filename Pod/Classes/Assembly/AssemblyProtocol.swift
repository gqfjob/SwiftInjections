//
//  AssemblyProtocol.swift
//  Pods
//
//  Created by Andrey Zarembo on 22.01.16.
//
//

import Foundation

public protocol ObjectInjector {
    
    func inject<ObjectType>(intoObject object:ObjectType, injectionBlock:(ObjectType)->ObjectType) -> ObjectType
    func instantiate<ObjectType>(withScope scope:ObjectScope, injectionBlock:(ObjectType)->ObjectType) -> ObjectType
    
    func object<ObjectType>(fromDefinition definition:Definition<ObjectType>) -> ObjectType
}

public protocol AssemblyProtocol: ObjectInjector {
    
    static func instance() -> Self
}

internal protocol AssemblyInternalProtocol {
    
    func detectViewControllersForAutoinjection()
}