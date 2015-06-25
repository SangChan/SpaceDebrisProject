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
#import "MyConst.h"
#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)

@interface GameScene () {
    Planet *_planet;
    SKSpriteNode *_satellite;
    SKShapeNode *_debris;
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
    _isTracking = NO;
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *creatDebris = [SKAction performSelector:@selector(initDebris) onTarget:self];
    SKAction *perform = [SKAction repeatActionForever:[SKAction sequence:@[wait,creatDebris]]];
    [self runAction:perform];
    
    _planet.physicsBody.angularVelocity = 1.0;
    
    _yourline1 = [SKShapeNode node];
    [_yourline1 setStrokeColor:[UIColor redColor]];
    [self addChild:_yourline1];
    _yourline2 = [SKShapeNode node];
    [_yourline2 setStrokeColor:[UIColor redColor]];
    [self addChild:_yourline2];
    _yourline3 = [SKShapeNode node];
    [_yourline3 setStrokeColor:[UIColor redColor]];
    [self addChild:_yourline3];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (_isTracking == NO) {
            _isTracking = YES;
            
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
    
//    CGFloat radius =  sqrt((self.size.width/2.0 * self.size.width/2.0) + (self.size.height/2.0*self.size.height/2.0));
//    float angle = _satellite.zRotation + SK_DEGREES_TO_RADIANS(-80.0f);
//    CGPoint satelliteStart = CGPointMake(_satellite.position.x, _satellite.position.y);
//    CGPoint satelliteEnd = CGPointMake(radius*cos(angle)+satelliteStart.x, radius*sin(angle)+satelliteStart.y);
    
    /*CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, satelliteStart.x,satelliteStart.y);
    CGPathAddLineToPoint(pathToDraw, NULL, satelliteEnd.x, satelliteEnd.y);
    _yourline1.path = pathToDraw;
    
    angle = _satellite.zRotation + SK_DEGREES_TO_RADIANS(-87.5f);
    satelliteEnd = CGPointMake(radius*cos(angle)+satelliteStart.x, radius*sin(angle)+satelliteStart.y);
    CGPathMoveToPoint(pathToDraw, NULL, satelliteStart.x,satelliteStart.y);
    CGPathAddLineToPoint(pathToDraw, NULL, satelliteEnd.x, satelliteEnd.y);
    _yourline2.path = pathToDraw;
    
    angle = _satellite.zRotation + SK_DEGREES_TO_RADIANS(-92.5f);
    satelliteEnd = CGPointMake(radius*cos(angle)+satelliteStart.x, radius*sin(angle)+satelliteStart.y);
    CGPathMoveToPoint(pathToDraw, NULL, satelliteStart.x,satelliteStart.y);
    CGPathAddLineToPoint(pathToDraw, NULL, satelliteEnd.x, satelliteEnd.y);
    _yourline3.path = pathToDraw;
    
    SKPhysicsBody *body = [self.physicsWorld bodyAlongRayStart:satelliteStart end:satelliteEnd];
    if (body.categoryBitMask == DEBRIS) {
        body.angularVelocity = 0.0;
        body.velocity = CGVectorMake(0.0, 0.0);
    }*/
    
    CGFloat radius =  sqrt((self.size.width/10.0 * self.size.width/10.0) + (self.size.height/10.0*self.size.height/10.0));
    CGPoint satelliteStart = CGPointMake(_satellite.position.x, _satellite.position.y);
    for (int i = 0; i < 90; i++) {
        float angle = _satellite.zRotation + SK_DEGREES_TO_RADIANS(-45.0f-i);
        CGPoint satelliteEnd = CGPointMake(radius*cos(angle)+satelliteStart.x, radius*sin(angle)+satelliteStart.y);
        
        SKPhysicsBody *body = [self.physicsWorld bodyAlongRayStart:satelliteStart end:satelliteEnd];
        if (body.categoryBitMask == DEBRIS) {
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
    _debris = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(13.0, 7.0)];
    //NSLog(@"radian = %f",radian);
    CGFloat radius =  sqrt((self.size.width/2.0 * self.size.width/2.0) + (self.size.height/2.0*self.size.height/2.0));
    _debris.position = CGPointMake(radius*cos(radian)+self.size.width*0.5, radius*sin(radian)+self.size.height*0.5);
    [_debris setFillColor:[UIColor brownColor]];
    
    _debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_debris.frame.size];
    _debris.physicsBody.dynamic = YES;
    _debris.physicsBody.density = 1;
    _debris.physicsBody.usesPreciseCollisionDetection = YES;
    _debris.physicsBody.categoryBitMask = DEBRIS;
    _debris.physicsBody.collisionBitMask = PLANET | SATELLITE | DEBRIS;
    _debris.physicsBody.contactTestBitMask = PLANET | SATELLITE | DEBRIS;

    [self addChild:_debris];
    //NSLog(@"planet x= %f, y= %f. debris x= %f, y =%f", _planet.position.x, _planet.position.y, _debris.position.x, _debris.position.y);
    
    CGVector throwVector = CGVectorMake((_planet.position.x - _debris.position.x) *0.25, (_planet.position.y - _debris.position.y) *0.25);
    //NSLog(@"vector = %f,%f", throwVector.dx, throwVector.dy);
    [_debris.physicsBody applyForce:throwVector];
    
}

-(void)resetController {
    _isTracking = NO;
    _satellite.physicsBody.angularVelocity = 0.0;
}

-(void)initSatellite {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    _satellite = [[Satellite alloc]initWithColor:[UIColor redColor] size:CGSizeMake(10.0,10.0)];
    _satellite.position = CGPointMake(centerPos.x, centerPos.y - 50 - 45);
    _satellite.anchorPoint = CGPointMake(0.5, 0.5);
    
    SKShapeNode *point = [SKShapeNode shapeNodeWithCircleOfRadius:2.0];
    [point setFillColor:[UIColor whiteColor]];
    point.position = CGPointMake(0,_satellite.frame.size.height/2 - 9.0);
    [_satellite addChild:point];
    
    SKSpriteNode *line1 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(20.0, 1.0)];
    line1.anchorPoint = CGPointMake(0, 0);
    line1.position = CGPointMake(0, 0);
    line1.zRotation = -M_PI * 0.25;
    [_satellite addChild:line1];
    SKSpriteNode *line2 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(20.0, 1.0)];
    line2.anchorPoint = CGPointMake(0, 0);
    line2.position = CGPointMake(0, 0);
    line2.zRotation = -M_PI * 0.75;
    [_satellite addChild:line2];
    
    _satellite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10.0, 10.0)];
    _satellite.physicsBody.dynamic = YES;
    _satellite.physicsBody.density = 1;
    _satellite.physicsBody.usesPreciseCollisionDetection = YES;
    _satellite.physicsBody.categoryBitMask = SATELLITE;
    _satellite.physicsBody.collisionBitMask = PLANET | DEBRIS;
    _satellite.physicsBody.contactTestBitMask = PLANET | DEBRIS;
    [self addChild:_satellite];
    
    
    CGPoint middleOfPlanet = CGPointMake(_planet.frame.origin.x + (_planet.frame.size.width * 0.5),_planet.frame.origin.y + (_planet.frame.size.height * 0.5));
    CGPoint middleOfSatellite = CGPointMake(_satellite.frame.origin.x + (_satellite.frame.size.width * 0.5),_satellite.frame.origin.y + (_satellite.frame.size.height * 0.5));
    
    SKPhysicsJointLimit *limitJoint = [SKPhysicsJointLimit jointWithBodyA:_planet.physicsBody bodyB:_satellite.physicsBody anchorA:middleOfPlanet anchorB:middleOfSatellite];
    [limitJoint setMaxLength:1.0];
    [self.physicsWorld addJoint:limitJoint];
    
    SKPhysicsJointPin *pinJoint = [SKPhysicsJointPin jointWithBodyA:_planet.physicsBody bodyB:_satellite.physicsBody anchor:middleOfSatellite];
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
        [self shakePlanet:5];
        contact.bodyA.velocity = CGVectorMake(0.0, 0.0);
        [contact.bodyA.node removeFromParent];
    }
}

-(void)shakePlanet:(NSInteger)times {
    CGPoint initialPoint = _planet.position;
    NSInteger amplitudeX = 10;
    NSInteger amplitudeY = 10;
    NSMutableArray *randomActions = [NSMutableArray array];
    for (int i=0; i<times; i++) {
        NSInteger randX = self.position.x+(arc4random() % amplitudeX);
        NSInteger randY = self.position.y+(arc4random() % amplitudeY);
        SKAction *action = [SKAction moveByX:randX y:randY duration:0.01];
        [randomActions addObject:action];
    }
    
    SKAction *rep = [SKAction sequence:randomActions];
    
    [_planet runAction:rep completion:^{
        _planet.position = initialPoint;
    }];
}


@end
