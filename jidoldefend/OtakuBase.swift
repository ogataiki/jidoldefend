import SpriteKit

class OtakuBase : SKSpriteNode {
    
    var tag: String = "";
    
    // 熱中度関連
    var passion: UInt32 = 0;
    var passionOverFlowLimit: UInt32 = 1000;
    var passionAddDistanceLimit: CGFloat = 160;
    var passionAddInterval: UInt32 = 250;
    var passionAddLastDate: NSDate = NSDate();
    
    // 新規オタク勧誘関連
    var newAddInterval: UInt32 = 1;
    var newAddPassionThreshold: UInt32 = 500;
    var newAddLastDate: NSDate = NSDate();
    var newAddCount: UInt32 = 0;
    var newAddCountLImit: UInt32 = 1 + (arc4random()%20);
    
    // オタクAIパターン
    enum AI: Int {
        case approach = 0
        case away = 1
    }
    var aiPattern: AI = AI.approach;
    
    // 推しメン
    // アイドル数が複数の場合はこれに設定する
    var targetIdol: Int = 0;
    
    // 帰宅関連
    var goHomeInterval: UInt32 = 7;
    var goHomeBaseDate: NSDate = NSDate();
    var isHome: Bool = false;
    var isHomeEffect: Bool = false;
    
    // パーティクル
    var passionFireParticle: SKEmitterNode!;
    var growPassionParticle: SKEmitterNode!;
    var downPassionParticle: SKEmitterNode!;
    
    // 台詞
    enum SpeechAction: Int {
        case normal = 0, jump, powerful
    }
    enum SpeechBalloon: String {
        case normal = "otaku_speech1"
        case powerful = "otaku_speech2"
        case rect = "otaku_speech3"
    }
    
    var isHevened: Bool = false;
    var isHevenedEffect: Bool = false;

    func addPassion(value: Int) {
        let date_now = NSDate();
        if(passion >= passionOverFlowLimit)
        {
            return;
        }
        let calendar = NSCalendar.currentCalendar()
        var comp: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitNanosecond
            , fromDate: passionAddLastDate
            , toDate: date_now
            , options:nil);
        let ms = comp.nanosecond / 100000;
        if ms > Int(passionAddInterval) {
            
            passionAddLastDate = date_now;
            if value < 0 {
                if(passion < UInt32(abs(value))) {
                    passion = 0;
                }
                else {
                    passion = passion - UInt32(abs(value));
                }
            }
            else {
                passion = passion + UInt32(value);
            }
        }
        //println("addPassion:\(value) passion:\(passion)");
    }
    
    func addNewOtaku() ->Bool {
        
        let date_now = NSDate();
        if passion >= newAddPassionThreshold {
            
            let calendar = NSCalendar.currentCalendar()
            var comp: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitSecond
                , fromDate: newAddLastDate
                , toDate: date_now
                , options:nil);
            let s = comp.second;
            if s > Int(newAddInterval) {
                
                newAddLastDate = date_now;
                if (arc4random() % 3 == 0)
                {
                    newAddCount++;
                    return true;
                }
            }
        }
        return false;
    }
    
    func isGoToHeven() -> Bool {
        if(passion >= passionOverFlowLimit || newAddCount > newAddCountLImit)
        {
            isHevened = true;
        }
        return isHevened;
    }
    
    func isGoHome() -> Bool {
        
        let date_now = NSDate();
        if passion == 0 {
            let calendar = NSCalendar.currentCalendar()
            var comp: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitSecond
                , fromDate: goHomeBaseDate
                , toDate: date_now
                , options:nil);
            let s = comp.second;
            if s > Int(goHomeInterval) {
                isHome = true;
            }
        }
        else {
            goHomeBaseDate = date_now;
        }
        return isHome;
    }
    
    func isActive() -> Bool {
        if isGoToHeven() == false && isGoHome() == false {
            return true;
        }
        return false;
    }
    
    
    func addGrowPassion(target: SKScene, z: CGFloat = 0) {
        
        if let fire = growPassionParticle {}
        else {
            let path = NSBundle.mainBundle().pathForResource("GrowPassion", ofType: "sks")!;
            var particle = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! SKEmitterNode
            
            particle.position = CGPointMake(self.position.x, self.position.y - self.size.height*0.2);
            
            //particle.numParticlesToEmit = 50 // 何個、粒を出すか。
            //particle.particleBirthRate = 50 // 一秒間に何個、粒を出すか。
            //particle.particleSpeed = 80 // 粒の速度
            //particle.xAcceleration = 0
            //particle.yAcceleration = 0 // 加速度を0にすることで、重力がないようになる。
            
            target.addChild(particle)
            particle.zPosition = z;
            
            growPassionParticle = particle;
        }
    }
    func updateGrowPassion() {
        if let fire = growPassionParticle {
            fire.position = CGPointMake(self.position.x, self.position.y - self.size.height*0.2);
        }
    }
    func removeGrowPassion() {
        
        if let fire = growPassionParticle {
            fire.removeFromParent();
            growPassionParticle = nil;
        }
    }
    
    func addDownPassion(target: SKScene, z: CGFloat = 0) {
        
        if let fire = downPassionParticle {}
        else {
            let path = NSBundle.mainBundle().pathForResource("DownPassion", ofType: "sks")!;
            var particle = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! SKEmitterNode
            
            particle.position = CGPointMake(self.position.x, self.position.y + self.size.height*0.25);
            
            //particle.numParticlesToEmit = 50 // 何個、粒を出すか。
            //particle.particleBirthRate = 50 // 一秒間に何個、粒を出すか。
            //particle.particleSpeed = 80 // 粒の速度
            //particle.xAcceleration = 0
            //particle.yAcceleration = 0 // 加速度を0にすることで、重力がないようになる。
            
            target.addChild(particle)
            particle.zPosition = z;
            
            downPassionParticle = particle;
        }
    }
    func updateDownPassion() {
        if let fire = downPassionParticle {
            fire.position = CGPointMake(self.position.x, self.position.y + self.size.height*0.25);
        }
    }
    func removeDownPassion() {
        
        if let fire = downPassionParticle {
            fire.removeFromParent();
            downPassionParticle = nil;
        }
    }

    func addPassionFire(target: SKScene, z: CGFloat = 0) {
        
        if let fire = passionFireParticle {}
        else {
            let path = NSBundle.mainBundle().pathForResource("PassionFire", ofType: "sks")!;
            var particle = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! SKEmitterNode
            
            particle.position = CGPointMake(self.position.x, self.position.y - self.size.height);
            
            //particle.numParticlesToEmit = 50 // 何個、粒を出すか。
            //particle.particleBirthRate = 50 // 一秒間に何個、粒を出すか。
            //particle.particleSpeed = 80 // 粒の速度
            //particle.xAcceleration = 0
            //particle.yAcceleration = 0 // 加速度を0にすることで、重力がないようになる。
            
            target.addChild(particle)
            particle.zPosition = z;
            
            passionFireParticle = particle;
        }
    }
    func updatePassionFire() {
        if let fire = passionFireParticle {
            fire.position = CGPointMake(self.position.x, self.position.y + self.size.height*0.1);
        }
    }
    func removePassionFire() {
        
        if let fire = passionFireParticle {
            fire.removeFromParent();
            passionFireParticle = nil;
        }
    }
    
    func updateAllParticle() {
        
        updateGrowPassion();
        updateDownPassion();
        updatePassionFire();
    }
    
    func removeAllPaticle() {
        
        removeGrowPassion();
        removeDownPassion();
        removePassionFire();
    }
    
    
    func runSpeech(text: String
        , balloon: SpeechBalloon
        , action: SpeechAction
        , frame: Int
        , target: SKScene
        , z: CGFloat
        , back: SKSpriteNode)
    {
        let speech = SpeechBase(imageNamed: balloon.rawValue);
        // 基本はキャラの左上に表示
        let widthoffset: CGFloat = 0.6;
        let heightoffset: CGFloat = 0.5;
        speech.position = CGPointMake(self.position.x - speech.size.width*widthoffset
            , self.position.y + speech.size.height*heightoffset);
        if(speech.position.x - speech.size.width*0.5 < target.frame.origin.x) {
            // 左が見切れる場合は右側に表示
            speech.position.x = self.position.x + speech.size.width*widthoffset;
            speech.xScale = -1.0;
        }
        if(speech.position.y + speech.size.height*0.5 > target.frame.origin.y + back.size.height) {
            // 上が見切れる場合は下側に表示
            speech.position.y = self.position.y - speech.size.height*heightoffset;
            speech.yScale = -1.0;
        }
        speech.zPosition = z;
        speech.addLabel(text);
        target.addChild(speech);        
        
        var seqActions: [SKAction] = [];
        switch(action) {
        case SpeechAction.normal:
            break;
        case SpeechAction.jump:
            seqActions.append(SKAction.moveBy(CGVectorMake(0.0, 0.1), duration: 0.1))
            seqActions.append(SKAction.moveBy(CGVectorMake(0.0, -0.1), duration: 0.1))
            seqActions.append(SKAction.moveBy(CGVectorMake(0.0, 0.1), duration: 0.1))
            seqActions.append(SKAction.moveBy(CGVectorMake(0.0, -0.1), duration: 0.1))
        case SpeechAction.powerful:
            let xscale = speech.xScale;
            let yscale = speech.yScale;
            speech.xScale = 0.0;
            speech.yScale = 0.0;
            
            seqActions.append(SKAction.group([SKAction.scaleXTo(xscale*1.2, duration: 0.2)
                , SKAction.scaleYTo(yscale*1.2, duration: 0.2)
                ]))
            seqActions.append(SKAction.group([SKAction.scaleXTo(xscale*0.95, duration: 0.1)
                , SKAction.scaleYTo(yscale*0.95, duration: 0.1)
                ]));
            seqActions.append(SKAction.group([SKAction.scaleXTo(xscale*1.0, duration: 0.1)
                , SKAction.scaleYTo(yscale*1.0, duration: 0.1)
                ]));
        default:
            break;
        }
        seqActions.append(SKAction.waitForDuration(1.0));
        let endfunc = SKAction.runBlock { () -> Void in
            speech.removeFromParent();
        }
        seqActions.append(endfunc);
        let seq = SKAction.sequence(seqActions);
        speech.runAction(seq);
    }
    
    func runHevenEffect(idolPos: CGPoint, target: SKScene, z: CGFloat, callback: (Int) -> Void) {
        
        let lightBall = SKSpriteNode(imageNamed: "spark.png");
        lightBall.blendMode = SKBlendMode.Add;
        lightBall.color = UIColor.yellowColor();
        lightBall.colorBlendFactor = 1.0;
        lightBall.zPosition = z;
        lightBall.xScale = 1.5;
        lightBall.yScale = 1.5;
        lightBall.position = self.position;
        target.addChild(lightBall);
        
        var face = SKSpriteNode(imageNamed: self.name!);
        face.blendMode = SKBlendMode.Add;
        face.color = UIColor.yellowColor();
        face.colorBlendFactor = 1.0;
        face.xScale = self.xScale;
        face.yScale = self.yScale;
        face.zPosition = 0;
        lightBall.addChild(face);

        var flashingBall = SKAction.sequence([
            SKAction.fadeAlphaTo(0.3, duration: 0.1),
            SKAction.fadeAlphaTo(1.0, duration: 0.1),
            SKAction.fadeAlphaTo(0.3, duration: 0.1),
            SKAction.fadeAlphaTo(1.0, duration: 0.1)
            ]);
        var jumpBall = SKActionEx.jumpTo(lightBall
            , targetPoint: idolPos
            , height: target.size.height - self.position.y
            , duration: 0.5);
        var endBall = SKAction.runBlock { () -> Void in
            lightBall.removeFromParent();
            callback(self.targetIdol);
        }
        var actionBall = SKAction.sequence([flashingBall, jumpBall, endBall]);
        lightBall.runAction(actionBall);
        
        for i in 0 ... 10 {
            let line = SKSpriteNode(imageNamed: "sparkline.png");
            line.blendMode = SKBlendMode.Add;
            line.color = UIColor.yellowColor();
            line.colorBlendFactor = 1.0;
            line.xScale = 0.5;
            line.yScale = 0.1;
            line.alpha = 0.0;
            line.zPosition = z;
            let pr = CGFloat(1 + (arc4random() % 10)) * 0.1;
            line.position = CGPointMake(self.position.x - self.size.width*0.5 + self.size.width*pr, self.position.y - self.size.height*0.5);
            line.anchorPoint = CGPointMake(0.5, 0.05);
            target.addChild(line);
            
            let r = NSTimeInterval(1 + arc4random() % 5);
            var wait = SKAction.waitForDuration(r * 0.1);

            var disp = SKAction.runBlock({ () -> Void in
                line.alpha = 1.0;
            });

            var grow = SKAction.group([
                SKAction.scaleXTo(0.1, duration: 0.1),
                SKAction.scaleYTo(2.0, duration: 0.2),
                SKAction.fadeAlphaTo(0, duration: 0.2)
                ]);
            
            var endLine = SKAction.runBlock { () -> Void in
                line.removeFromParent();
            }
            var actionLine = SKAction.sequence([wait, disp, grow, endLine]);
            line.runAction(actionLine);
        }
    }
  
    func runHomeEffect(idolPos: CGPoint, target: SKScene, z: CGFloat, callback: (Int) -> Void) {
        
        let lightBall = SKSpriteNode(imageNamed: "spark.png");
        lightBall.blendMode = SKBlendMode.Add;
        lightBall.color = UIColor.blueColor();
        lightBall.colorBlendFactor = 1.0;
        lightBall.zPosition = z;
        lightBall.xScale = 1.5;
        lightBall.yScale = 1.5;
        lightBall.position = self.position;
        target.addChild(lightBall);
        
        var face = SKSpriteNode(imageNamed: self.name!);
        face.blendMode = SKBlendMode.Add;
        face.color = UIColor.blueColor();
        face.colorBlendFactor = 1.0;
        face.xScale = self.xScale;
        face.yScale = self.yScale;
        face.zPosition = 0;
        lightBall.addChild(face);
        
        var flashingBall = SKAction.sequence([
            SKAction.fadeAlphaTo(0.3, duration: 0.1),
            SKAction.fadeAlphaTo(1.0, duration: 0.1),
            SKAction.fadeAlphaTo(0.3, duration: 0.1),
            SKAction.fadeAlphaTo(1.0, duration: 0.1)
            ]);
        var jumpBall = SKActionEx.jumpTo(lightBall
            , targetPoint: idolPos
            , height: target.size.height - self.position.y
            , duration: 0.5);
        var endBall = SKAction.runBlock { () -> Void in
            lightBall.removeFromParent();
            callback(self.targetIdol);
        }
        var actionBall = SKAction.sequence([flashingBall, jumpBall, endBall]);
        lightBall.runAction(actionBall);
        
        for i in 0 ... 10 {
            let line = SKSpriteNode(imageNamed: "sparkline.png");
            line.blendMode = SKBlendMode.Add;
            line.color = UIColor.blueColor();
            line.colorBlendFactor = 1.0;
            line.xScale = 0.5;
            line.yScale = 0.1;
            line.alpha = 0.0;
            line.zPosition = z;
            let pr = CGFloat(1 + (arc4random() % 10)) * 0.1;
            line.position = CGPointMake(self.position.x - self.size.width*0.5 + self.size.width*pr, self.position.y - self.size.height*0.5);
            line.anchorPoint = CGPointMake(0.5, 0.05);
            target.addChild(line);
            
            let r = NSTimeInterval(1 + arc4random() % 5);
            var wait = SKAction.waitForDuration(r * 0.1);
            
            var disp = SKAction.runBlock({ () -> Void in
                line.alpha = 1.0;
            });
            
            var grow = SKAction.group([
                SKAction.scaleXTo(0.1, duration: 0.1),
                SKAction.scaleYTo(2.0, duration: 0.2),
                SKAction.fadeAlphaTo(0, duration: 0.2)
                ]);
            
            var endLine = SKAction.runBlock { () -> Void in
                line.removeFromParent();
            }
            var actionLine = SKAction.sequence([wait, disp, grow, endLine]);
            line.runAction(actionLine);
        }
    }

    func runDefaultAction() {
        let rot1 = SKAction.rotateByAngle(CGFloat(M_PI*0.05), duration:0.05)
        let stay1 = SKAction.waitForDuration(0.4);
        let rot2 = SKAction.rotateByAngle(CGFloat(-(M_PI*0.05*2)), duration:0.1)
        let stay2 = SKAction.waitForDuration(0.4);
        let rot3 = SKAction.rotateByAngle(CGFloat(M_PI*0.05), duration:0.05)
        let seq = SKAction.sequence([rot1, stay1, rot2, stay2, rot3]);
        
        self.runAction(SKAction.repeatActionForever(seq));
    }
}