//
//  AssemblyProtocol.swift
//  Pods
//
//  Created by Andrey Zarembo on 22.01.16.
//
//

import Foundation

public protocol ObjectInjector {

}

public protocol AssemblyProtocol: ObjectInjector {
    
    static func instance() -> Self
}