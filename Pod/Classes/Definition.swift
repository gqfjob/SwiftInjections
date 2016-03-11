//
//  Definition.swift
//  Pods
//
//  Created by Andrey Zarembo on 10.03.16.
//
//

import Foundation

public class Definition {
    
    var assembly:Assembly
    var key:String
    var scope:Scope
    
    init(assembly:Assembly,key:String, scope:Scope) {
        self.assembly = assembly
        self.key = key
        self.scope = scope
    }
    
    public func initObject<ObjectType:AnyObject>(@autoclosure initBlock:()->ObjectType)->ObjectType {
        return self.assembly.instantiateObject(withDefinition: self, objectInitblock: initBlock)
    }
}