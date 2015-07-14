import SpriteKit

class SpeechBase : SKSpriteNode {
 
    var label: SKLabelNode!;
    func setText (text: String) {
        if let l = label {
            label.removeFromParent();
            label = nil;
        }
        label = SKLabelNode(text: text);
        label.fontColor = UIColor.blackColor();
        label.fontSize = 14;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        label.xScale = self.xScale;
        label.yScale = self.yScale;
        self.addChild(label);
    }
}