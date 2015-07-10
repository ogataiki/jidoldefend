import SpriteKit

class IdolBase : SKSpriteNode {
    
    var fear: UInt32 = 0;
    var fearOverFlowLimit: UInt32 = 1000;

    var moveTargetIndex: UInt32 = 0;
    var isMoving: Bool = false;
    var movingDate: NSDate = NSDate();
    var moveNextInterval: Int = 0;
    var moveVector: CGSize = CGSizeZero;

    var isQuited: Bool = false;
    
    func isQuit() -> Bool {
        if(fear > fearOverFlowLimit)
        {
            isQuited = true;
            return true;
        }
        return false;
    }
}