//
//  SingletonDependencyResolver.swift
//  mail
//
//  Created by Andrey Zarembo on 12.01.16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

import Foundation
import SwiftDispatch

struct SingletonInstanceMetadata {
    var sharedInstance:Any? = nil
    var dispatchOnceToken:DispatchOnceToken = 0
    var firstRunInitialization:Bool = false
}

class SingletonDependencyResolver: DependencyResolver {
    
    var metadata:[String:SingletonInstanceMetadata] = [String:SingletonInstanceMetadata]()

    func resolveDependency<DependencyTargetType>(objectInitBlock: DependencyResolverObjectInitBlock) -> DependencyTargetType? {
            
        let objectTypeName:String = String(DependencyTargetType)
        
        var metadata = self.metadata[objectTypeName] ?? SingletonInstanceMetadata()
        dispatchOnce(withToken: &metadata.dispatchOnceToken) {
            metadata.firstRunInitialization = true
        }
        if metadata.firstRunInitialization {
            metadata.firstRunInitialization = false
            self.metadata[objectTypeName] = metadata
            metadata.sharedInstance = objectInitBlock()
        }
        self.metadata[objectTypeName] = metadata
        return metadata.sharedInstance as? DependencyTargetType
    }
}