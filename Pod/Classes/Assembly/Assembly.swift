//
//  Assembly.swift
//  Pods
//
//  Created by Andrey Zarembo on 22.01.16.
//
//

import Foundation
import SwiftRuntime
import SwiftDispatch

public class Assembly: AssemblyProtocol {
    
    public required init() {}
    
    public var singletons:[AnyObjectDefinition:Any] = [:]
    public var weakSingletons:[AnyObjectDefinition:WeakReferenceStorage] = [:]
    
    public class func instance() -> Self {
        return self.resolvedInstance()!
    }
    
    internal class func resolvedInstance() -> Self? {
        
        struct StaticDataHolder {
            static var assemblyResolver:SingletonDependencyResolver? = nil
            static var dispatchOnceToken: DispatchOnceToken = 0
            static var firstCall:Bool = false
        }
        
        dispatchOnce(withToken: &StaticDataHolder.dispatchOnceToken) {
            StaticDataHolder.firstCall = true
        }
        if StaticDataHolder.firstCall {
            StaticDataHolder.firstCall = false
            StaticDataHolder.assemblyResolver = SingletonDependencyResolver()
        }
        return StaticDataHolder.assemblyResolver?.resolveDependency() {
            let object = self.init()
            let assembly = object as Assembly
            return assembly
        }
    }
    
    private func instantiateObject<ObjectType>(fromDefinition definition:Definition<ObjectType>) -> ObjectType {
        
        print("Using definition: \(unsafeAddressOf(definition)) for Object: \(ObjectType.self)")
        
        switch definition.scope {
        case .ObjectGraph:
            return self.objectWithObjectGraphScope(fromDefinition: definition)
        case .Prototype:
            return self.objectWithPrototypeScope(fromDefinition: definition)
        case .Singleton:
            return self.objectWithSingletonScope(fromDefinition: definition)
        case .LazySingleton:
            return self.objectWithLazySingletonScope(fromDefinition: definition)
        case .WeakSingleton:
            if let _ = ObjectType.self as? AnyObject.Type {
                return self.objectWithLazySingletonScope(fromDefinition: definition)
            }
            else {
                return self.objectWithPrototypeScope(fromDefinition: definition)
            }
        }
    }
    
    private func objectWithObjectGraphScope<ObjectType>(fromDefinition definition:Definition<ObjectType>) -> ObjectType {
        
        var shouldClearInjectionStack:Bool = false
        var injectionStack:InjectionStack! = NSThread.currentThread().getObject(forKey: "InjectionStack")
        if injectionStack == nil {
            injectionStack = InjectionStack()
            shouldClearInjectionStack = true
            NSThread.currentThread().setObject(injectionStack, withKey: "InjectionStack", refenceType: .Strong)
        }
        
        var object:ObjectType! = injectionStack.objectGraphScopeDefinitions[definition] as? ObjectType
        if object == nil {
            object = definition.objectInitBlock()
            injectionStack.objectGraphScopeDefinitions[definition] = object
            object = definition.objectInjectBlock(object: object)
        }
        
        if shouldClearInjectionStack {
            injectionStack = nil
            NSThread.currentThread().setObject(injectionStack, withKey: "InjectionStack", refenceType: .Strong)
        }
        
        return object
    }
    
    private func objectWithPrototypeScope<ObjectType>(fromDefinition definition:Definition<ObjectType>) -> ObjectType {
        return definition.objectInjectBlock( object: definition.objectInitBlock() )
    }
    
    private func objectWithSingletonScope<ObjectType>(fromDefinition definition:Definition<ObjectType>) -> ObjectType {
        
        return self.singletons[definition] as! ObjectType
    }
    
    private func objectWithLazySingletonScope<ObjectType>(fromDefinition definition:Definition<ObjectType>) -> ObjectType {
        
        if let object = self.singletons[definition] as? ObjectType {
            return object
        }
        
        self.buildSingletonObject(fromDefinition: definition)
        return self.objectWithSingletonScope(fromDefinition: definition)
    }
    
    private func objectWithWeakSingletonScope<ObjectType:AnyObject>(fromDefinition definition:Definition<ObjectType>) -> ObjectType {
        
        if let weakReferenceStorage = self.weakSingletons[definition],
           let weakObjectLink = weakReferenceStorage.weakLink as? ObjectType {
            return weakObjectLink
        }
        
        let object = definition.objectInjectBlock( object: definition.objectInitBlock() )
        self.weakSingletons[definition] = WeakReferenceStorage(weakLink: object)
        
        return object
    }
    
    private func buildSingletonObject<ObjectType>(fromDefinition definition:Definition<ObjectType>){
        self.singletons[definition] = definition.objectInjectBlock( object: definition.objectInitBlock() )
    }

    public func bluePrint<ObjectType>(withScope scope:Scope, objectInitBlock:()->ObjectType, objectInjectBlock:(object:ObjectType)->ObjectType)->ObjectBlueprint<ObjectType> {
        return ObjectBlueprint<ObjectType>(withBuildBlock: { (definition) in
            return self.instantiateObject(fromDefinition: definition)
        }, definition: Definition<ObjectType>(withScope: scope,
            objectInitBlock: objectInitBlock,
            objectInjectBlock: objectInjectBlock)
            )
    }
}

public class WeakReferenceStorage {
    weak var weakLink:AnyObject? = nil
    init(weakLink: AnyObject?) {
        self.weakLink = weakLink
    }
}