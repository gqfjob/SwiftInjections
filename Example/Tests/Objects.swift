import Foundation

public class BaseObject: Equatable {
  
    public init() {
    }
}

/// Первый объект для тестирования внедрения зависимостей
public class Object1:BaseObject {
    
    /// В него внедряется "Object2"
    public var object2:Object2!
    
    /// Внедрение enum
    public var enumValue:TestEnum!
}

/// Второй объект для тестирования внедрения зависимостей
public class Object2:BaseObject {
    
    /// В него внедряется "Object1", создается циклическая зависимость
    public var object1:Object1!
}

/// Третий объект для тестирования внедрения зависимостей
public class Object3:BaseObject {
    
    /// В него внедряются несколько "Object4" в виде прототипов
    public var objects4:[Object4] = [Object4]()
}

/// Четвертый объект для тестирования внедрения зависимостей
public class Object4:BaseObject {
    
    /// В каждый объект внедряется исходная копия "Object3"
    public var object3:Object3!
}

/// Пятный объект для тестирования синглетонов
public class Object5:BaseObject {
    
    /// В него внедряется "Object6" из ObjectGraph
    public var object6:Object6!
}

/// Шестой объект для тестирования синглетонов
public class Object6:BaseObject {
    
    /// В него внедряется "Object5" Синглетон
    public var object5:Object5!
    
    /// Фабричный метод для объектов
    public class func buildObject()->Object6 {
        return Object6()
    }
}

/// Тестовый протокол для объекта
public protocol TestObjectProtocol: AnyObject {
    
    var object1:Object1! { get set }
}
/// Тестовый объект с доступом по протоколу
public class Object7:BaseObject, TestObjectProtocol {
    
    public var object1:Object1!
}

/// Тестовый Enum для внедрения
public enum TestEnum {
    case TestValue1
    case TestValue2
}

public func ==(left:BaseObject?, right:BaseObject?)->Bool {
    guard let leftObject = left, let rightObject = right else {
        return false
    }
    return ObjectIdentifier(leftObject).uintValue == ObjectIdentifier(rightObject).uintValue
}

public func ==(left:BaseObject, right:BaseObject)->Bool {
    return ObjectIdentifier(left).uintValue == ObjectIdentifier(right).uintValue
}

