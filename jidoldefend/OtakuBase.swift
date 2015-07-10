import SpriteKit

class OtakuBase : SKSpriteNode {
    
    var tag: String = "";
    
    // 熱中度関連
    var passion: UInt32 = 0;
    var passionOverFlowLimit: UInt32 = 1000;
    var passionAddDistanceLimit: CGFloat = 150;
    var passionAddInterval: UInt32 = 250;
    var passionAddLastDate: NSDate = NSDate();
    
    // 新規オタク勧誘関連
    var newAddInterval: UInt32 = 1;
    var newAddPassionThreshold: UInt32 = 500;
    var newAddLastDate: NSDate = NSDate();
    var newAddCount: UInt32 = 0;
    var newAddCountLImit: UInt32 = 1 + (arc4random()%20);
    
    // 推しメン
    var targetIdol: Int = Int(arc4random() % 2);
    
    // 帰宅関連
    var goHomeInterval: UInt32 = 7;
    var goHomeBaseDate: NSDate = NSDate();
    var isHome: Bool = false;
    
    // パーティクル
    var passionFireParticle: SKEmitterNode!;
    var growPassionParticle: SKEmitterNode!;
    var downPassionParticle: SKEmitterNode!;
    
    var isHevened: Bool = false;

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
            
            particle.position = CGPointMake(self.position.x, self.position.y - self.size.height*0.5);
            
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
            fire.position = CGPointMake(self.position.x, self.position.y - self.size.height*0.5);
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
            
            particle.position = CGPointMake(self.position.x, self.position.y + self.size.height*0.3);
            
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
            fire.position = CGPointMake(self.position.x, self.position.y + self.size.height*0.3);
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
            
            particle.position = CGPointMake(self.position.x, self.position.y);
            
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
            fire.position = CGPointMake(self.position.x, self.position.y);
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

}