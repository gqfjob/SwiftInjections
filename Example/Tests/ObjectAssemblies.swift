import Foundation
import SwiftInjections

public class Assembly1: Assembly {
    
    lazy var assembly2 = Assembly2.instance()
    
    public var object1:Object1 {
        return self.define() { (definition) in
            
            let object1 = definition *~> Object1()
            object1.object2 = self.assembly2.object2
            object1.enumValue = self.testEnum
            return object1
        }
    }
    
    public var object3:Object3 {
        return self.define() { (definition) in
            
            let object3 = definition *~> Object3()
            for _ in 0..<5 {
                object3.objects4.append(self.object4)
            }
            
            return object3
        }
    }
    
    public var object4:Object4 {
        return self.define(withKey: "Object4",scope: .Prototype) { (definition) in
            
            let object4 = definition *~> Object4()
            object4.object3 = self.object3
            return object4
        }
    }
    
    public var object5:Object5 {
        return self.define(withScope: .Singleton) { (definition) in
            
            let object5 = definition *~> Object5()
            object5.object6 = self.object6
            return object5
        }
    }
    
    public var object6:Object6 {
        return self.define(withScope: .Prototype) { (definition) in
            
            let object6 = definition *~> Object6.buildObject()
            object6.object5 = self.object5
            return object6
        }
    }
    
    public var object7:TestObjectProtocol {
        return self.define() { (definition) in
            let object7 = definition *~> Object7()
            return object7
        }
    }
    
    public var testEnum:TestEnum {
        return self.define() { (definition) in
            let testEnum = definition *~> TestEnum.TestValue2
            return testEnum
        }
    }
    
    public func injectIntoObject8( inputObject8:Object8 )->Object8 {
        return self.define() { (definition) in
            let object8 = definition *~> inputObject8
            object8.object9 = self.object9
            return object8
        }
    }
    
    public var object9:Object9 {
        return self.define() { (definition) in
            let object9 = definition *~> Object9()
            object9.object8 = self.existingObjectByMatchingType()
            return object9
        }
    }
}

public class Assembly2: Assembly {
    
    lazy var assembly1 = Assembly1.instance()
    
    public var object2:Object2 {
        return self.define() { (definition) in
            
            let object2 = definition *~> Object2()
            object2.object1 = self.assembly1.object1
            return object2
        }
    }
    
}