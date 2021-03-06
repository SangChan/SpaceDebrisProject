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
#import "Space.h"
#import "MyConst.h"
#import "AGSpriteButton.h"
#import "NSString+FontAwesome.h"


@interface GameScene () {
    Space *_space;
    Planet *_planet;
    Satellite *_satellite;
    SKShapeNode *_beamShape;
    BOOL _isTracking;
    int timer;
    
}

@end

@implementation GameScene

#pragma mark - setup scene

-(void)didMoveToView:(SKView *)view {
    self.physicsWorld.gravity =  CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    [self gameStart];
}

#pragma mark - touch events

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

#pragma mark - update frame

-(void)update:(CFTimeInterval)currentTime {
    static CGFloat currentRotation;
    /* Called before each frame is rendered */
    for (SKNode *childNode in [self children]) {
        if ([childNode respondsToSelector:@selector(update)]) {
            [childNode performSelector:@selector(update)];
        }
    }
    if(currentRotation != _satellite.zRotation) {
        [_space setRotation:(_satellite.zRotation > currentRotation) ? (-1)*_satellite.zRotation : _satellite.zRotation];
    }
    
    if (_satellite.shoot && _satellite.battery > _satellite.energyDrain * 2.0) {
        [self satelliteShootTheBeam];
        [_satellite usePower];
    }
    else if(!_satellite.shoot) {
        [self resetController];
        [_satellite chargePower];
    }
    
    //Maybe 1 second per 30 count.
    currentRotation = _satellite.zRotation;
    timer++;
}

#pragma mark - satellite

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
    
    _beamShape.zPosition = CG_BEAM;
    _beamShape.path = arcPath;
    [_beamShape setFillColor:[UIColor cyanColor]];
    
    [_beamShape setAlpha:0.3 * (_satellite.battery / 100.0)];
    CGPathRelease(arcPath);

}

#pragma mark - initialize

-(void)initBackGround {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    _space = [Space sharedInstanceWithPosition:centerPos];
    _space.zPosition = BG_ALL;
    [self addChild:_space];
}

-(void)initPlanet {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    _planet =[Planet sharedInstanceWithPosition:centerPos Radius:50.0];
    [_planet resetDamege];
    _planet.zPosition = CG_PLANET;
    [self addChild:_planet];
}


-(void)initDebris {
    float radian = randomFromMinToMax(0, M_PI);
    CGFloat radius =  sqrt(pow(self.size.width * 0.5, 2.0) + pow(self.size.height * 0.5, 2.0));
    Debris *debris = [[Debris alloc]initWithPosition:CGPointMake(radius*cos(radian)+self.size.width*0.5, radius*sin(radian)+self.size.height*0.5) Radian:radian];
    debris.zPosition = CG_DEBRIS;
    [self addChild:debris];
    
    int i = 5;
    CGPoint distance = ccpSub(_planet.position, debris.position);
    CGPoint magneticForce = ccpMult(ccpNormalize(distance), radius / i);
    CGVector throwVector = CGVectorMake(magneticForce.x,magneticForce.y);
    
    NSLog(@"vector = %f,%f. length = %f. radius = %f", throwVector.dx, throwVector.dy, ccpLength(magneticForce), radius);
    [debris.physicsBody applyForce:throwVector];
}


-(void)initSatellite {
    _satellite = [[Satellite alloc]initWithPosition:CGPointMake(_planet.fixedPosition.x, _planet.fixedPosition.y - _planet.fixedRadius - 70)];
    _satellite.beamLength = sqrt(pow(self.size.width/10.0,2.0) + pow(self.size.height/10.0,2.0));
    _satellite.zPosition = CG_SATELLITE;
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

#pragma mark - physics delegate

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"collison impulse : %f, contact normal vector.dx : %f , dy : %f",contact.collisionImpulse, contact.contactNormal.dx, contact.contactNormal.dy);
    if (contact.bodyA.categoryBitMask == DEBRIS && contact.bodyB.categoryBitMask == PLANET) {
        //TODO : BANG BANG KA-BOOOOOOM!
        Debris *debris = (Debris *)contact.bodyA.node;
        [_planet getDamage:debris.attackPoint];
        [debris boomWithFire];
        if ([_planet healthPoint] <= 0) {
            //TODO : game over!
            [self gameOver];
        }
    }
    else if (contact.bodyA.categoryBitMask == DEBRIS && contact.bodyB.categoryBitMask == SATELLITE) {
        //TODO : Satellite get stunned
        NSLog(@"contact DEBRIS between SATELLITE");
    }
}

#pragma mark - game life cycle

-(void)gameStart {
    timer = 0;
    [self initBackGround];
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

-(void)gameOver {
    UIImage *screenShot = [self getBluredScreenshot];
    [self removeAllActions];
    [self removeAllChildren];
    [self.physicsWorld removeAllJoints];
    [self loadBlurWithImage:screenShot];
}

-(void)gameRestart {
    [[self childNodeWithName:@"pauseBG"] removeFromParent];
    [[self childNodeWithName:@"retryButton"] removeFromParent];
    
    [self gameStart];
}

#pragma mark - private methods

-(void)resetController {
    _isTracking = NO;
    _satellite.shoot = NO;
    _beamShape.hidden = YES;
    _satellite.physicsBody.angularVelocity = 0.0;
}

-(void)loadBlurWithImage:(UIImage*)image {
    SKSpriteNode *pauseBG = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image] size:self.size];
    pauseBG.name = @"pauseBG";
    pauseBG.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    pauseBG.alpha = 0.1;
    pauseBG.zPosition = 2;
    [pauseBG runAction:[SKAction fadeAlphaTo:1 duration:0.3]];
    [self addChild:pauseBG];
    
    SKLabelNode *wordLabel = [[SKLabelNode alloc]initWithFontNamed:@"Chalkduster"];
    wordLabel.text = @"Game Over";
    wordLabel.fontSize = 36;
    wordLabel.fontColor = [UIColor whiteColor];
    wordLabel.position = CGPointMake(0.0, 100.0);
    [pauseBG addChild:wordLabel];
    
    SKLabelNode *timeLabel = [[SKLabelNode alloc]initWithFontNamed:@"Chalkduster"];
    timeLabel.text = [NSString stringWithFormat:@"You saved earth for %d seconds!",timer/60];
    timeLabel.fontSize = 36;
    timeLabel.fontColor = [UIColor whiteColor];
    timeLabel.position = CGPointMake(0.0, -100.0);
    [pauseBG addChild:timeLabel];
    
    AGSpriteButton *retryButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(100, 100)];
    retryButton.name = @"retryButton";
    [retryButton setLabelWithText:[NSString fontAwesomeIconStringForEnum:FARepeat] andFont:[UIFont fontWithName:kFontAwesomeFamilyName size:50.0] withColor:[UIColor whiteColor]];
    retryButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    retryButton.alpha = 0.1;
    retryButton.zPosition = 3;
    [retryButton runAction:[SKAction fadeAlphaTo:1 duration:0.5]];
    [self addChild:retryButton];
    [retryButton addTarget:self selector:@selector(gameRestart) withObject:nil forControlEvent:AGButtonControlEventTouchUpInside];
}

- (UIImage *)getBluredScreenshot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1);
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
    UIImage *ss = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[ss CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@5 forKey:kCIInputRadiusKey];
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGRect rect = [outputImage extent];
    rect.origin.x += (rect.size.width - ss.size.width ) / 2;
    rect.origin.y += (rect.size.height - ss.size.height) / 2;
    rect.size = ss.size;
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:rect];
    UIImage *image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return image;
}


@end
