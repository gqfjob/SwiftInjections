import Foundation

public class Assembly1: Assembly {
    
    lazy var assembly2 = Assembly2.instance()
    
    public var object1:Object1! {
        return self.injectObject() {
            let object1 = self ~> Object1()
            object1.object2 = self.assembly2.object2
            return object1
        }
    }
    
    public var object3:Object3! {
        return self.injectObject() {
            
            let object3 = self ~> Object3()
            for _ in 0..<5 {
                object3.objects4.append(self.object4)
            }
            
            return object3
        }
    }
    
    public var object4:Object4! {
        return self.prototypeObject() {
            
            let object4 = self ~> Object4()
            object4.object3 = self.object3
            return object4
        }
    }
    
    public var object5:Object5! {
        return self.singletonObject() {
            
            let object5 = self ~> Object5()
            object5.object6 = self.object6
            return object5
        }
    }
    
    public var object6:Object6! {
        return self.prototypeObject() {
            
            let object6 = self ~> Object6.buildObject()
            object6.object5 = self.object5
            return object6
        }
    }
    
}

public class Assembly2: Assembly {
    
    lazy var assembly1 = Assembly1.instance()
    public var object2:Object2! {
        return self.injectObject() {
            let object2 = self ~> Object2()
            object2.object1 = self.assembly1.object1
            return object2
        }
    }
}