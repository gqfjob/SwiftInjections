import Foundation
import SwiftDispatch

/// Базовый класс Assembly
public class Assembly {
    
    /// Метод создания синглетоном для Assemblies. Такой сложный, чтобы можно было наследоваться от класса и получать синглетоны
    public static func instance()->Self {
        /// Статическое хранилище токенов и инстансов
        struct Static {
            static var onceTokens:[String:dispatch_once_t] = [String:dispatch_once_t]()
            static var instances:[String:Assembly] = [String:Assembly]()
        }

        let className = String(self)
        var dispatchToken:dispatch_once_t = Static.onceTokens[className] ?? 0
        
        /// Создание инстанса вынесено из dispatch_once, чтобы не возникало дедлока
        var createInstance:Bool = false
        dispatch_once(&dispatchToken) {
            createInstance = true
        }
        
        Static.onceTokens[className] = dispatchToken
        if createInstance {
            Static.instances[className] = self.init()
        }
        
        return castAssemblyInstance(Static.instances[className]!, asType: self)
    }
    
    /// Костыль-инициализатор
    public required init() {
    }
    
    /// Стек объектов, которые создаются для ObjectGraph
    static var objectStack:[String:Any] = [String:Any]()
    static var objectStackDepth:Int = 0
    
    /// Объекты-синглетоны
    var singletons:[String:Any] = [String:Any]()
    
    public func define<ObjectType>(injectBlock:(definition:Definition)->ObjectType)->ObjectType {
        return self.define(withKey: String(ObjectType), scope: Scope.ObjectGraph, injectBlock: injectBlock)
    }
    
    public func define<ObjectType>(withKey key:String,injectBlock:(definition:Definition)->ObjectType)->ObjectType {
        
        return self.define(withKey: key, scope: Scope.ObjectGraph, injectBlock: injectBlock)
    }

    public func define<ObjectType:Any>(withScope scope:Scope,injectBlock:(definition:Definition)->ObjectType)->ObjectType {
        
        return self.define(withKey: String(ObjectType), scope: scope, injectBlock: injectBlock)
    }
    
    public func define<ObjectType>(withKey key:String,scope:Scope,injectBlock:(definition:Definition)->ObjectType)->ObjectType {
        
        let definition:Definition = Definition(assembly: self, key: key, scope: scope)
        
        var object:ObjectType
        
        /// Прототип создается всегда через вызовы блока
        switch scope {

        case .Prototype:

            object = injectBlock(definition: definition)
            
        case .ObjectGraph:
            fallthrough
        case .Singleton:
            
            /// Если объект есть, возвращается он
            print("\(ObjectType.self) / \(Assembly.objectStack[key])")
            if let objectFromStack = Assembly.objectStack[key] as? ObjectType {
                object = objectFromStack
            }
            else {
                /// Если объекта нет, погружаемся в стек на 1 уровень, создаем объект,
                /// сохраняем его в связке с ключем и вызываем лок внедрения. После чего выходим из стека на 1 уровень.
                /// Если есть циклическая связь, то вернется инициализированный объект без циклического вызова injectionBlock
                Assembly.objectStackDepth += 1
                object = injectBlock(definition: definition)
                Assembly.objectStackDepth -= 1
            }
            if Assembly.objectStackDepth == 0 {
                Assembly.objectStack.removeAll()
            }
        }
        
        return object
    }
    
    /// Инициализирует объект в зависимости от областей создания объектов
    /// @autoclosure автоматически оборачивает код в closure, чтобы можно было явно вызывать инициализатор, когда это требуется
    /// Отделение инициализатора нужно, чтобы разорвать цепной вызов injectionBlock и вернуть объект, если он уже был инициализирован для objectGraph
    internal func instantiateObject<ObjectType>(withDefinition definition:Definition, @noescape objectInitblock:()->ObjectType)->ObjectType {
        
        let objectKey = definition.key
        
        switch definition.scope {
        case .Prototype:
            
            return objectInitblock()
            
        case .ObjectGraph:
            
            if let object = Assembly.objectStack[objectKey] as? ObjectType {
                return object
            }
            else {
                let object = objectInitblock()
                Assembly.objectStack[objectKey] = object
                return object
            }
            
        case .Singleton:
            if let object = self.singletons[objectKey] as? ObjectType {
                Assembly.objectStack[objectKey] = object
                return object
            }
            else {
                let object = objectInitblock()
                self.singletons[objectKey] = object
                Assembly.objectStack[objectKey] = object
                return object
            }
        }
    }
    
    public func existingObjectByMatchingType<ObjectType>()->ObjectType? {
        let key = String(ObjectType)
        return self.existingObject(withKey: key)
    }
    public func existingObject<ObjectType>(withKey key:String)->ObjectType? {
        return Assembly.objectStack[key] as? ObjectType
    }
}

infix operator *~> { precedence 90 }
public func *~><ObjectType>(definition:Definition, @autoclosure objectInitClosure:()->ObjectType)->ObjectType {
    
    return definition.assembly.instantiateObject(withDefinition: definition, objectInitblock: objectInitClosure)
}

/// Специальная функция-костыль для преобразования типов с учетом наследования
func castAssemblyInstance<T>(instance: Any, asType type: T.Type) -> T {
    return instance as! T
}