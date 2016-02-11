//
//  ComponentResolver.swift
//  Pods
//
//  Created by Andrey Zarembo on 23.01.16.
//
//

import Foundation

public class ComponentResolver<ComponentType> {
    
    public typealias ComponentResolverBlock = ()->ComponentType?
    
    var componentInitBlock:ComponentResolverBlock
    
    public init(componentInitBlock:ComponentResolverBlock) {
        self.componentInitBlock = componentInitBlock
    }
    
    public func instance()->ComponentType? {
        return self.componentInitBlock()
    }
}