import SpriteKit

class SpeechBase : SKSpriteNode {
 
    enum ZCtrl: CGFloat {
        case label = 0
    }
    var label: SKLabelNode!;
    func addLabel (_ text: String) {
        if (label) != nil {
            label.removeFromParent();
            label = nil;
        }
        label = SKLabelNode(text: text);
        label.fontColor = UIColor.black;
        label.fontSize = 14;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center;
        label.xScale = self.xScale;
        label.yScale = self.yScale;
        label.zPosition = ZCtrl.label.rawValue;
        self.addChild(label);
    }
    
    func remove() {
        label.removeFromParent();
        label = nil;
        self.removeFromParent();
    }
}
