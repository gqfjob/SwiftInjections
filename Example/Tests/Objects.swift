import Foundation

/// Первый объект для тестирования внедрения зависимостей
public class Object1:CustomDebugStringConvertible {
    
    
    /// В него внедряется "Object2"
    public var object2:Object2!
    
    public init() {
    }
    
    public var debugDescription: String {
        return "Object1: \(ObjectIdentifier(self).uintValue) object2:\( self.object2 == nil ? "nil" : String(ObjectIdentifier(self.object2).uintValue))"
    }
}

/// Второй объект для тестирования внедрения зависимостей
public class Object2:CustomDebugStringConvertible {
    
    /// В него внедряется "Object1", создается циклическая зависимость
    public var object1:Object1!
    
    public init() {
    }
    public var debugDescription: String {
        return "Object2: \(ObjectIdentifier(self).uintValue) object1:\( self.object1 == nil ? "nil" : String(ObjectIdentifier(self.object1).uintValue))"
    }
}

/// Третий объект для тестирования внедрения зависимостей
public class Object3:CustomDebugStringConvertible {
    
    /// В него внедряются несколько "Object4" в виде прототипов
    public var objects4:[Object4] = [Object4]()
    
    public init() {
    }
    public var debugDescription: String {
        return "Object3: \(ObjectIdentifier(self).uintValue) objects4:\(self.objects4)"
    }
}

/// Четвертый объект для тестирования внедрения зависимостей
public class Object4:CustomDebugStringConvertible {
    
    /// В каждый объект внедряется исходная копия "Object3"
    public var object3:Object3!
    
    public init() {
    }
    public var debugDescription: String {
        return "Object4: \(ObjectIdentifier(self).uintValue) object3:\( self.object3 == nil ? "nil" : String(ObjectIdentifier(self.object3).uintValue))"
    }
}

/// Пятный объект для тестирования синглетонов
public class Object5:CustomDebugStringConvertible {
    
    /// В него внедряется "Object6" из ObjectGraph
    public var object6:Object6!
    
    public init() {
    }
    public var debugDescription: String {
        return "Object5: \(ObjectIdentifier(self).uintValue) object6:\( self.object6 == nil ? "nil" : String(ObjectIdentifier(self.object6).uintValue))"
    }
}

/// Шестой объект для тестирования синглетонов
public class Object6:CustomDebugStringConvertible {
    
    /// В него внедряется "Object5" Синглетон
    public var object5:Object5!
    
    public init() {
    }
    public var debugDescription: String {
        return "Object6: \(ObjectIdentifier(self).uintValue) object5:\( self.object5 == nil ? "nil" : String(ObjectIdentifier(self.object5).uintValue))"
    }
    
    public class func buildObject()->Object6 {
        return Object6()
    }
}

/// Первый объект для тестирования внедрения зависимостей
public class Object7:CustomDebugStringConvertible {
    
    
    /// В него внедряется "Object8"
    public var object8:Object8!
    
    public init() {
    }
    
    public var debugDescription: String {
        return "Object7: \(ObjectIdentifier(self).uintValue) object8:\( self.object8 == nil ? "nil" : String(ObjectIdentifier(self.object8).uintValue))"
    }
}

/// Второй объект для тестирования внедрения зависимостей
public class Object8:CustomDebugStringConvertible {
    
    /// В него внедряется "Object1", создается циклическая зависимость
    public var object7:Object7!
    
    public init() {
    }
    public var debugDescription: String {
        return "Object8: \(ObjectIdentifier(self).uintValue) object7:\( self.object7 == nil ? "nil" : String(ObjectIdentifier(self.object7).uintValue))"
    }
}