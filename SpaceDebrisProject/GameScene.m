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
    Debris *_debris;
    SKShapeNode *_yourline1;
    SKShapeNode *_yourline2;
    SKShapeNode *_yourline3;
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
    
    _yourline1 = [SKShapeNode node];
    [_yourline1 setStrokeColor:[UIColor cyanColor]];
    [self addChild:_yourline1];
    _yourline2 = [SKShapeNode node];
    [_yourline2 setStrokeColor:[UIColor cyanColor]];
    [self addChild:_yourline2];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (_isTracking == NO) {
            _isTracking = YES;
            _satellite.shoot = YES;
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
    
    CGFloat radius =  sqrt(pow(self.size.width/10.0,2.0) + pow(self.size.height/10.0,2.0));
    CGPoint satelliteStart = CGPointMake(_satellite.position.x, _satellite.position.y);
    for (int i = 0; i < 90; i++) {
        float angle = _satellite.zRotation + SK_DEGREES_TO_RADIANS(-45.0f-i);
        CGPoint satelliteEnd = CGPointMake(radius*cos(angle)+satelliteStart.x, radius*sin(angle)+satelliteStart.y);
        
        SKPhysicsBody *body = [self.physicsWorld bodyAlongRayStart:satelliteStart end:satelliteEnd];
        if (body.categoryBitMask == DEBRIS) {
            Debris *targetDebris = (Debris *)body.node;
            targetDebris.active = NO;
            body.resting = YES;
            body.angularVelocity = 0.0;
            body.velocity = CGVectorMake(0.0, 0.0);
        }
        
        if (i == 0) {
            CGMutablePathRef pathToDraw = CGPathCreateMutable();
            CGPathMoveToPoint(pathToDraw, NULL, satelliteStart.x,satelliteStart.y);
            CGPathAddLineToPoint(pathToDraw, NULL, satelliteEnd.x, satelliteEnd.y);
            _yourline1.path = pathToDraw;
        }
        
        if (i == 89) {
            CGMutablePathRef pathToDraw = CGPathCreateMutable();
            CGPathMoveToPoint(pathToDraw, NULL, satelliteStart.x,satelliteStart.y);
            CGPathAddLineToPoint(pathToDraw, NULL, satelliteEnd.x, satelliteEnd.y);
            _yourline2.path = pathToDraw;
        }

    }
}


-(void)initPlanet {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    _planet = [[Planet alloc]initWithPosition:centerPos Radius:50.0];
    
    [self addChild:_planet];
}


-(void)initDebris {
    float radian = [self randomFromMin:0.0 toMax:M_PI];
    
    NSLog(@"radian = %f",radian);
    
    CGFloat radius =  sqrt(pow(self.size.width * 0.5, 2.0) + pow(self.size.height * 0.5, 2.0));
    
    _debris = [[Debris alloc]initWithPosition:CGPointMake(radius*cos(radian)+self.size.width*0.5, radius*sin(radian)+self.size.height*0.5)];
   
    [self addChild:_debris];
    //NSLog(@"planet x= %f, y= %f. debris x= %f, y =%f", _planet.position.x, _planet.position.y, _debris.position.x, _debris.position.y);
    
    CGVector throwVector = CGVectorMake((_planet.position.x - _debris.position.x) *0.25, (_planet.position.y - _debris.position.y) *0.25);
    NSLog(@"vector = %f,%f", throwVector.dx, throwVector.dy);
    [_debris.physicsBody applyForce:throwVector];
    
}

-(void)resetController {
    _isTracking = NO;
    _satellite.shoot = NO;
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

-(float)randomFromMin:(float)min toMax:(float)max{
    return (float) rand()/RAND_MAX * (max - min) + min;
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"collison impulse : %f, contact normal vector.dx : %f , dy : %f",contact.collisionImpulse, contact.contactNormal.dx, contact.contactNormal.dy);
    if (contact.bodyA.categoryBitMask == DEBRIS && contact.bodyB.categoryBitMask == PLANET) {
        //TODO : BANG BANG KA-BOOOOOOM!
        [_planet getDamage:contact.bodyA.mass];
        contact.bodyA.velocity = CGVectorMake(0.0, 0.0);
        [contact.bodyA.node removeFromParent];
    }
}


@end
