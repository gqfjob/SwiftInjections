//
//  Scope.swift
//  Pods
//
//  Created by Andrey Zarembo on 10.03.16.
//
//

import Foundation


/// Области создания объектов
public enum Scope {
    /// Прототип
    case Prototype
    /// Граф объектов
    case ObjectGraph
    /// Синглетон
    case Singleton
}