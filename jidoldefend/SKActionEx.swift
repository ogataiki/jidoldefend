import SpriteKit

//SKアクションの拡張クラス群

class SKActionEx: SKNode {
    
    static func jumpTo(_ sprite: SKSpriteNode, targetPoint: CGPoint, height: CGFloat, duration: TimeInterval) -> SKAction {
        
        let startPoint = sprite.position
        
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.move(to: startPoint)
        var controlPoint: CGPoint = CGPoint()
        controlPoint.x = startPoint.x + (targetPoint.x - startPoint.x)/2
        controlPoint.y = startPoint.y + height
        bezierPath.addQuadCurve(to: targetPoint, controlPoint: controlPoint)
        
        let jumpAction = SKAction.follow(bezierPath.cgPath, asOffset:false, orientToPath:false, duration: 0.2)
        jumpAction.timingMode = .easeIn
        let scaleA = SKAction.scale(to: 1.2, duration: 0.1)
        let scaleB = SKAction.scale(to: 1.0, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleA,scaleB])
        let sequence = SKAction.group([jumpAction, scaleSequence])
        return sequence
    }
}
