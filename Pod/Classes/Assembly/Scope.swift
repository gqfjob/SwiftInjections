//
//  Scope.swift
//  Pods
//
//  Created by Andrey Zarembo on 24.01.16.
//
//

import Foundation

public class ObjectScope: Equatable, Hashable {
    
    public typealias ObjectInitBlock = ()->Any

    private var scopeAddress:UnsafePointer<Void> {
        get {
            return unsafeAddressOf(self)
        }
    }
    
    public var initBlock:ObjectInitBlock
    public init(initBlock:ObjectInitBlock) {
        self.initBlock = initBlock
    }
    
    public var hashValue:Int {
        get {
            return self.scopeAddress.hashValue
        }
    }
}

public func == (left:ObjectScope, right:ObjectScope)->Bool {
    return left.scopeAddress == right.scopeAddress
}

public class ObjectGraphScope: ObjectScope {
    public override init(initBlock:ObjectInitBlock) {
        super.init(initBlock:initBlock)
    }

}