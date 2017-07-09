import SpriteKit

class OtakuBase : SKSpriteNode {
    
    var tag: String = "";
    
    // 熱中度関連
    var passion: UInt32 = 0;
    var passionOverFlowLimit: UInt32 = 2000;
    var passionAddDistanceLimit: CGFloat = 160;
    var passionAddInterval: UInt32 = 250;
    var passionAddLastDate: Date = Date();
    var passionGoHevenThreshold: UInt32 = 500;
    
    // 生存期限
    var generateDate: Date = Date();
    var timeLimit: UInt32 = 15;
    var isHevened: Bool = false;
    var isHevenedEffect: Bool = false;
    var isHome: Bool = false;
    var isHomeEffect: Bool = false;
    enum Result: UInt32 {
        case goHome = 0
        case goHeven = 1
    }
    func isTimeLimit() -> (limit: Bool, result: Result) {
        
        if isPassionOverFlow() {
            return (true, Result.goHeven);
        }
        
        let date_now = Date();
        let calendar = Calendar.current
        var comp: DateComponents = calendar.dateComponents([Calendar.Component.second]
            , from: generateDate
            , to: date_now);
        let sec = comp.second;
        var limit = false;
        if sec! > Int(timeLimit) {
            limit = true;
        }
        var goHeven = Result.goHome;
        if passion > passionGoHevenThreshold {
            goHeven = Result.goHeven;
        }
        return (limit, goHeven);
    }
    
    func isPassionOverFlow() -> Bool {
        if passion >= passionOverFlowLimit {
            return true;
        }
        return false;
    }
    
    // オタクAIパターン
    enum AI: Int {
        case approach = 0
        case away = 1
    }
    var aiPattern: AI = AI.approach;
    
    // 推しメン
    // アイドル数が複数の場合はこれに設定する
    var targetIdol: Int = 0;
    
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
    

    func addPassion(_ value: Int) {
        let date_now = Date();
        if(passion >= passionOverFlowLimit)
        {
            return;
        }
        let calendar = Calendar.current
        var comp: DateComponents = calendar.dateComponents([Calendar.Component.nanosecond]
            , from: passionAddLastDate
            , to: date_now);
        let ms = comp.nanosecond! / 100000;
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
    
    func addGrowPassion(_ target: SKScene, z: CGFloat = 0) {
        
        if (growPassionParticle) != nil {}
        else {
            let path = Bundle.main.path(forResource: "GrowPassion", ofType: "sks")!;
            let particle = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! SKEmitterNode
            
            particle.position = CGPoint(x: self.position.x, y: self.position.y - self.size.height*0.2);
            
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
            fire.position = CGPoint(x: self.position.x, y: self.position.y - self.size.height*0.2);
        }
    }
    func removeGrowPassion() {
        
        if let fire = growPassionParticle {
            fire.removeFromParent();
            growPassionParticle = nil;
        }
    }
    
    func addDownPassion(_ target: SKScene, z: CGFloat = 0) {
        
        if (downPassionParticle) != nil {}
        else {
            let path = Bundle.main.path(forResource: "DownPassion", ofType: "sks")!;
            let particle = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! SKEmitterNode
            
            particle.position = CGPoint(x: self.position.x, y: self.position.y + self.size.height*0.25);
            
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
            fire.position = CGPoint(x: self.position.x, y: self.position.y + self.size.height*0.25);
        }
    }
    func removeDownPassion() {
        
        if let fire = downPassionParticle {
            fire.removeFromParent();
            downPassionParticle = nil;
        }
    }

    func addPassionFire(_ target: SKScene, z: CGFloat = 0) {
        
        if (passionFireParticle) != nil {}
        else {
            let path = Bundle.main.path(forResource: "PassionFire", ofType: "sks")!;
            let particle = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! SKEmitterNode
            
            particle.position = CGPoint(x: self.position.x, y: self.position.y - self.size.height);
            
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
            fire.position = CGPoint(x: self.position.x, y: self.position.y + self.size.height*0.1);
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
    
    
    func runSpeech(_ text: String
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
        speech.position = CGPoint(x: self.position.x - speech.size.width*widthoffset
            , y: self.position.y + speech.size.height*heightoffset);
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
            seqActions.append(SKAction.move(by: CGVector(dx: 0.0, dy: 0.1), duration: 0.1))
            seqActions.append(SKAction.move(by: CGVector(dx: 0.0, dy: -0.1), duration: 0.1))
            seqActions.append(SKAction.move(by: CGVector(dx: 0.0, dy: 0.1), duration: 0.1))
            seqActions.append(SKAction.move(by: CGVector(dx: 0.0, dy: -0.1), duration: 0.1))
        case SpeechAction.powerful:
            let xscale = speech.xScale;
            let yscale = speech.yScale;
            speech.xScale = 0.0;
            speech.yScale = 0.0;
            
            seqActions.append(SKAction.group([SKAction.scaleX(to: xscale*1.2, duration: 0.2)
                , SKAction.scaleY(to: yscale*1.2, duration: 0.2)
                ]))
            seqActions.append(SKAction.group([SKAction.scaleX(to: xscale*0.95, duration: 0.1)
                , SKAction.scaleY(to: yscale*0.95, duration: 0.1)
                ]));
            seqActions.append(SKAction.group([SKAction.scaleX(to: xscale*1.0, duration: 0.1)
                , SKAction.scaleY(to: yscale*1.0, duration: 0.1)
                ]));
        }
        seqActions.append(SKAction.wait(forDuration: 1.0));
        let endfunc = SKAction.run { () -> Void in
            speech.removeFromParent();
        }
        seqActions.append(endfunc);
        let seq = SKAction.sequence(seqActions);
        speech.run(seq);
    }
    
    func runHevenEffect(_ idolPos: CGPoint, target: SKScene, z: CGFloat, callback: @escaping (OtakuBase) -> Void) {
        
        let lightBall = SKSpriteNode(imageNamed: "spark.png");
        lightBall.blendMode = SKBlendMode.add;
        lightBall.color = UIColor.yellow;
        lightBall.colorBlendFactor = 1.0;
        lightBall.zPosition = z;
        lightBall.xScale = 1.5;
        lightBall.yScale = 1.5;
        lightBall.position = self.position;
        target.addChild(lightBall);
        
        let face = SKSpriteNode(imageNamed: self.name!);
        face.blendMode = SKBlendMode.add;
        face.color = UIColor.yellow;
        face.colorBlendFactor = 1.0;
        face.xScale = self.xScale;
        face.yScale = self.yScale;
        face.zPosition = 0;
        lightBall.addChild(face);

        let flashingBall = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1),
            SKAction.fadeAlpha(to: 0.3, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
            ]);
        let jumpBall = SKActionEx.jumpTo(lightBall
            , targetPoint: idolPos
            , height: target.size.height - self.position.y
            , duration: 0.5);
        let endBall = SKAction.run { () -> Void in
            lightBall.removeFromParent();
            callback(self);
        }
        let actionBall = SKAction.sequence([flashingBall, jumpBall, endBall]);
        lightBall.run(actionBall);
        
        for _ in 0 ... 10 {
            let line = SKSpriteNode(imageNamed: "sparkline.png");
            line.blendMode = SKBlendMode.add;
            line.color = UIColor.yellow;
            line.colorBlendFactor = 1.0;
            line.xScale = 0.5;
            line.yScale = 0.1;
            line.alpha = 0.0;
            line.zPosition = z;
            let pr = CGFloat(1 + (arc4random() % 10)) * 0.1;
            line.position = CGPoint(x: self.position.x - self.size.width*0.5 + self.size.width*pr, y: self.position.y - self.size.height*0.5);
            line.anchorPoint = CGPoint(x: 0.5, y: 0.05);
            target.addChild(line);
            
            let r = TimeInterval(1 + arc4random() % 5);
            let wait = SKAction.wait(forDuration: r * 0.1);

            let disp = SKAction.run({ () -> Void in
                line.alpha = 1.0;
            });

            let grow = SKAction.group([
                SKAction.scaleX(to: 0.1, duration: 0.1),
                SKAction.scaleY(to: 2.0, duration: 0.2),
                SKAction.fadeAlpha(to: 0, duration: 0.2)
                ]);
            
            let endLine = SKAction.run { () -> Void in
                line.removeFromParent();
            }
            let actionLine = SKAction.sequence([wait, disp, grow, endLine]);
            line.run(actionLine);
        }
    }
  
    func runHomeEffect(_ idolPos: CGPoint, target: SKScene, z: CGFloat, callback: @escaping (OtakuBase) -> Void) {
        
        let lightBall = SKSpriteNode(imageNamed: "spark.png");
        lightBall.blendMode = SKBlendMode.add;
        lightBall.color = UIColor.blue;
        lightBall.colorBlendFactor = 1.0;
        lightBall.zPosition = z;
        lightBall.xScale = 1.5;
        lightBall.yScale = 1.5;
        lightBall.position = self.position;
        target.addChild(lightBall);
        
        let face = SKSpriteNode(imageNamed: self.name!);
        face.blendMode = SKBlendMode.add;
        face.color = UIColor.blue;
        face.colorBlendFactor = 1.0;
        face.xScale = self.xScale;
        face.yScale = self.yScale;
        face.zPosition = 0;
        lightBall.addChild(face);
        
        let flashingBall = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1),
            SKAction.fadeAlpha(to: 0.3, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
            ]);
        let jumpBall = SKActionEx.jumpTo(lightBall
            , targetPoint: idolPos
            , height: target.size.height - self.position.y
            , duration: 0.5);
        let endBall = SKAction.run { () -> Void in
            lightBall.removeFromParent();
            callback(self);
        }
        let actionBall = SKAction.sequence([flashingBall, jumpBall, endBall]);
        lightBall.run(actionBall);
        
        for _ in 0 ... 10 {
            let line = SKSpriteNode(imageNamed: "sparkline.png");
            line.blendMode = SKBlendMode.add;
            line.color = UIColor.blue;
            line.colorBlendFactor = 1.0;
            line.xScale = 0.5;
            line.yScale = 0.1;
            line.alpha = 0.0;
            line.zPosition = z;
            let pr = CGFloat(1 + (arc4random() % 10)) * 0.1;
            line.position = CGPoint(x: self.position.x - self.size.width*0.5 + self.size.width*pr, y: self.position.y - self.size.height*0.5);
            line.anchorPoint = CGPoint(x: 0.5, y: 0.05);
            target.addChild(line);
            
            let r = TimeInterval(1 + arc4random() % 5);
            let wait = SKAction.wait(forDuration: r * 0.1);
            
            let disp = SKAction.run({ () -> Void in
                line.alpha = 1.0;
            });
            
            let grow = SKAction.group([
                SKAction.scaleX(to: 0.1, duration: 0.1),
                SKAction.scaleY(to: 2.0, duration: 0.2),
                SKAction.fadeAlpha(to: 0, duration: 0.2)
                ]);
            
            let endLine = SKAction.run { () -> Void in
                line.removeFromParent();
            }
            let actionLine = SKAction.sequence([wait, disp, grow, endLine]);
            line.run(actionLine);
        }
    }

    func runDefaultAction() {
        let rot1 = SKAction.rotate(byAngle: CGFloat(Double.pi*0.05), duration:0.05)
        let stay1 = SKAction.wait(forDuration: 0.4);
        let rot2 = SKAction.rotate(byAngle: CGFloat(-(Double.pi*0.05*2)), duration:0.1)
        let stay2 = SKAction.wait(forDuration: 0.4);
        let rot3 = SKAction.rotate(byAngle: CGFloat(Double.pi*0.05), duration:0.05)
        let seq = SKAction.sequence([rot1, stay1, rot2, stay2, rot3]);
        
        self.run(SKAction.repeatForever(seq));
    }
}
