//
//  DependencyResolverProtocol.swift
//  mail
//
//  Created by Andrey Zarembo on 12.01.16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

import Foundation

typealias DependencyResolverObjectInitBlock = ()->AnyObject?

protocol DependencyResolver {
    func resolveDependency<DependencyTargetType>(objectInitBlock: DependencyResolverObjectInitBlock)->DependencyTargetType?
}