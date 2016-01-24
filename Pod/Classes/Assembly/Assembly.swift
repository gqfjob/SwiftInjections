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

public class Assembly: AssemblyProtocol, AssemblyInternalProtocol {
    
    public required init() {}
    
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
            assembly.detectViewControllersForAutoinjection()
            return assembly
        }
    }
    
    public func inject<ObjectType>(intoObject object: ObjectType, injectionBlock: (ObjectType) -> ObjectType) -> ObjectType {
        return self.instantiate(withInitBlock: { return object}, injectionBlock: injectionBlock)
    }
    
    public func object<ObjectType>(fromDefinition definition:Definition<ObjectType>) -> ObjectType {
        
        let object = definition.objectInitBlock()
        let injectedObject = definition.objectInjectBlock(object: object)
        return injectedObject
    }
    
    public func instantiate<ObjectType>(withScope scope:ObjectScope, injectionBlock:(ObjectType)->ObjectType) -> ObjectType {
        
        var injectionStack:InjectionStack? = NSThread.currentThread().getObject(forKey: "InjectionStack")
        if injectionStack == nil {
            injectionStack = InjectionStack()
            NSThread.currentThread().setObject(injectionStack, withKey: "InjectionStack", refenceType: .Strong)
        }
        
        let object:ObjectType
        
        if let createdObject = injectionStack?.objectGraphScopes[scope] {
            object = createdObject as! ObjectType
        } else {
            object = scope.initBlock() as! ObjectType
            injectionStack?.objectGraphScopes[scope] = object
        }
        
        let injectedObject:ObjectType = injectionBlock(object)
        
        return injectedObject
    }
    
    public func instantiate<ObjectType>(withInitBlock initBlock:()->ObjectType, injectionBlock:(ObjectType)->ObjectType) -> ObjectType {
        
//        let address:Int64 = unsafeBitCast(initBlock.self, Int64.self)
        print("block: \(String(initBlock))")
        
        
        
        var injectionStack:InjectionStack? = NSThread.currentThread().getObject(forKey: "InjectionStack")
        if injectionStack == nil {
           injectionStack = InjectionStack()
            NSThread.currentThread().setObject(injectionStack, withKey: "InjectionStack", refenceType: .Strong)
        }
        
        // Проверка, нет ли уже объекта
        let objectAfterInit:ObjectType = initBlock()
        
        // Проверка, не бы ло внедрения
        return injectionBlock(objectAfterInit)
    }
    
    internal func detectViewControllersForAutoinjection() {
        self.printMirror(self)
    }
    
    internal func printMirror(object:Any, depth:Int=0) {
        let mirror = Mirror(reflecting: object)
        print("CHILDREN OF \(object) as \(object.dynamicType)")
        
        for child in mirror.children {
            print("CHILD #\(depth): \(child.label) > \(child.value)")
            self.printMirror(child.value, depth: depth+1)
        }
    }
    
}

public class AssemblyPlaceholder: Assembly {
    
}