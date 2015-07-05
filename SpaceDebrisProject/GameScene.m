//
//  GameScene.m
//  SpaceDebrisProject2
//
//  Created by SangChan on 2015. 6. 8..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "GameScene.h"
#import "Satellite.h"
#import "Planet.h"
#import "Debris.h"
#import "MyConst.h"


@interface GameScene () {
    Planet *_planet;
    Satellite *_satellite;
    SKShapeNode *_beamShape;
    CFTimeInterval _startTime;
    CFTimeInterval _currentTime;
    BOOL _isTracking;
}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.gravity =  CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    _startTime = 0.0;
    [self initPlanet];
    
    
    [self initSatellite];
    
    [self initJointWithNodeA:_planet NodeB:_satellite];
    _isTracking = NO;
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *creatDebris = [SKAction performSelector:@selector(initDebris) onTarget:self];
    SKAction *perform = [SKAction repeatActionForever:[SKAction sequence:@[wait,creatDebris]]];
    [self runAction:perform];
    
    _planet.physicsBody.angularVelocity = 1.0;
    
    _beamShape = [SKShapeNode node];
    [_beamShape setStrokeColor:[UIColor cyanColor]];
    [self addChild:_beamShape];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (_isTracking == NO) {
            _isTracking = YES;
            _satellite.shoot = YES;
            _beamShape.hidden = NO;
            float deltaX = location.x - _satellite.position.x;
            float deltaY = location.y - _satellite.position.y;
            _satellite.physicsBody.angularVelocity = 0.0;
            float angle = atan2f(deltaY, deltaX);
            _satellite.zRotation = angle - SK_DEGREES_TO_RADIANS(-90.0f);
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (_isTracking == YES) {
            _satellite.shoot = YES;
            _beamShape.hidden = NO;
            float deltaX = location.x - _satellite.position.x;
            float deltaY = location.y - _satellite.position.y;
            _satellite.physicsBody.angularVelocity = 0.0;
            float angle = atan2f(deltaY, deltaX);
            _satellite.zRotation = angle - SK_DEGREES_TO_RADIANS(-90.0f);
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resetController];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resetController];
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    for (SKNode *childNode in [self children]) {
        if ([childNode respondsToSelector:@selector(update)]) {
            [childNode performSelector:@selector(update)];
        }
    }
    
    if (_satellite.shoot) {
        [self satelliteShootTheBeam];
    }
}

-(void)satelliteShootTheBeam {
    
    CGFloat radius =  sqrt(pow(self.size.width/10.0,2.0) + pow(self.size.height/10.0,2.0));
    CGPoint satelliteStart = CGPointMake(_satellite.position.x, _satellite.position.y);
    CGMutablePathRef arcPath = CGPathCreateMutable();
    for (int i = 0; i < 30; i++) {
        float angle = _satellite.zRotation + SK_DEGREES_TO_RADIANS(-45.0f-i*3);
        CGPoint satelliteEnd = CGPointMake(radius*cos(angle)+satelliteStart.x, radius*sin(angle)+satelliteStart.y);
        
        SKPhysicsBody *body = [self.physicsWorld bodyAlongRayStart:satelliteStart end:satelliteEnd];
        if (body.categoryBitMask == DEBRIS) {
            Debris *targetDebris = (Debris *)body.node;
            [targetDebris becomeGold];
            //targetDebris.active = NO;
            //body.resting = YES;
            //body.angularVelocity = 0.0;
            //body.velocity = CGVectorMake(0.0, 0.0);
        }
        else if (body.categoryBitMask == PLANET) {
            CGFloat newRadius =  sqrt(pow(self.size.width/30.0,2.0) + pow(self.size.height/30.0,2.0));
            satelliteEnd = CGPointMake(newRadius*cos(angle)+satelliteStart.x, newRadius*sin(angle)+satelliteStart.y);
        }
        
        if (i == 0) {
            CGPathMoveToPoint(arcPath, NULL, satelliteStart.x,satelliteStart.y);
            CGPathAddLineToPoint(arcPath, NULL, satelliteEnd.x, satelliteEnd.y);
        }
        else if (i == 29) {
            CGPathAddLineToPoint(arcPath, NULL, satelliteEnd.x, satelliteEnd.y);
            CGPathAddLineToPoint(arcPath, NULL, satelliteStart.x, satelliteStart.y);
        }
        
        else {
            CGPathAddLineToPoint(arcPath, NULL, satelliteEnd.x, satelliteEnd.y);
        }
        
    }
    
    _beamShape.path = arcPath;
    [_beamShape setFillColor:[UIColor cyanColor]];
    [_beamShape setAlpha:0.3];
    CGPathRelease(arcPath);

}


-(void)initPlanet {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    _planet =[Planet sharedInstanceWithPosition:centerPos Radius:50.0];
    
    [self addChild:_planet];
}


-(void)initDebris {
    float radian = randomFromMinToMax(0, M_PI);
    NSLog(@"radian = %f",radian);
    CGFloat radius =  sqrt(pow(self.size.width * 0.5, 2.0) + pow(self.size.height * 0.5, 2.0));
    Debris *debris = [[Debris alloc]initWithPosition:CGPointMake(radius*cos(radian)+self.size.width*0.5, radius*sin(radian)+self.size.height*0.5) Radian:radian];
   
    [self addChild:debris];
    
    int i = 5;
    CGPoint distance = ccpSub(_planet.position, debris.position);
    CGPoint magneticForce = ccpMult(ccpNormalize(distance), radius / i);
    CGVector throwVector = CGVectorMake(magneticForce.x,magneticForce.y);
    
    NSLog(@"vector = %f,%f. length = %f. radius = %f", throwVector.dx, throwVector.dy, ccpLength(magneticForce), radius);
    [debris.physicsBody applyForce:throwVector];
}

-(void)resetController {
    _isTracking = NO;
    _satellite.shoot = NO;
    _beamShape.hidden = YES;
    _satellite.physicsBody.angularVelocity = 0.0;
}

-(void)initSatellite {
    _satellite = [[Satellite alloc]initWithPosition:CGPointMake(_planet.fixedPosition.x, _planet.fixedPosition.y - _planet.fixedRadius - 45)];
    _satellite.beamLength = sqrt(pow(self.size.width/10.0,2.0) + pow(self.size.height/10.0,2.0));
    [self addChild:_satellite];
}

-(void)initJointWithNodeA:(SKNode *)nodeA NodeB:(SKNode *)nodeB {
    CGPoint middleOfNodeA = CGPointMake(nodeA.frame.origin.x + (nodeA.frame.size.width * 0.5),nodeA.frame.origin.y + (nodeA.frame.size.height * 0.5));
    CGPoint middleOfNodeB = CGPointMake(nodeB.frame.origin.x + (nodeB.frame.size.width * 0.5),nodeB.frame.origin.y + (nodeB.frame.size.height * 0.5));
    
    SKPhysicsJointLimit *limitJoint = [SKPhysicsJointLimit jointWithBodyA:nodeA.physicsBody bodyB:nodeB.physicsBody anchorA:middleOfNodeA anchorB:middleOfNodeB];
    [limitJoint setMaxLength:1.0];
    [self.physicsWorld addJoint:limitJoint];
    
    SKPhysicsJointPin *pinJoint = [SKPhysicsJointPin jointWithBodyA:nodeA.physicsBody bodyB:nodeB.physicsBody anchor:middleOfNodeB];
    [self.physicsWorld addJoint:pinJoint];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"collison impulse : %f, contact normal vector.dx : %f , dy : %f",contact.collisionImpulse, contact.contactNormal.dx, contact.contactNormal.dy);
    if (contact.bodyA.categoryBitMask == DEBRIS && contact.bodyB.categoryBitMask == PLANET) {
        //TODO : BANG BANG KA-BOOOOOOM!
        Debris *debris = (Debris *)contact.bodyA.node;
        [_planet getDamage:debris.attackPoint];
        [debris boom_boom_kaboom];
        //[contact.bodyA.node removeFromParent];
    }
    else if (contact.bodyA.categoryBitMask == DEBRIS && contact.bodyB.categoryBitMask == SATELLITE) {
        //TODO : Satellite get stunned
    }
}


@end
