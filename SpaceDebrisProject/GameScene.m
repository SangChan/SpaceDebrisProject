//
//  GameScene.m
//  SpaceDebrisProject2
//
//  Created by SangChan on 2015. 6. 8..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () {
    SKShapeNode *planet;
    SKShapeNode *satellite;
}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.gravity =  CGVectorMake(0.0, 0.0);
    
    [self initPlanet];
    [self initSatellite];
    [self initDebris];
    
    SKAction *action = [SKAction rotateByAngle:M_PI duration:10];
    [planet runAction:[SKAction repeatActionForever:action]];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /*for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }*/
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)initPlanet {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    
    planet = [SKShapeNode shapeNodeWithCircleOfRadius:50.0];

    [planet setFillColor:[UIColor blueColor]];
    
    planet.position = CGPointMake(centerPos.x,centerPos.y);
    
    SKShapeNode *point = [SKShapeNode shapeNodeWithCircleOfRadius:5.0];
    [point setFillColor:[UIColor whiteColor]];
    point.position = CGPointMake(0,planet.frame.size.height/2 - 9.0);
    [planet addChild:point];
    
    planet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5.0];
    
    [self addChild:planet];
}

-(void)initSatellite {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    satellite = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(10.0,10.0) cornerRadius:2.5];
    
    satellite.position = CGPointMake(centerPos.x, centerPos.y + planet.frame.size.width/2 + 10);
    
    [satellite setFillColor:[UIColor redColor]];
    
    satellite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10.0, 10.0)];
    
    [self addChild:satellite];
    
    SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:planet.physicsBody bodyB:satellite.physicsBody anchorA:CGPointMake(planet.frame.origin.x, planet.frame.origin.y) anchorB:CGPointMake(satellite.frame.origin.x, satellite.frame.origin.y)];
    joint.maxLength = 10.0;
    [self.physicsWorld addJoint:joint];
    
    [satellite.physicsBody applyForce:CGVectorMake(1.0, 1.0)];
}

-(void)initDebris {
    
}
     


-(SKTexture*)textureWithVerticalGradientofSize:(CGSize)size topColor:(CIColor*)topColor bottomColor:(CIColor*)bottomColor
{
    CIContext *coreImageContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIFilter *gradientFilter = [CIFilter filterWithName:@"CILinearGradient"];
    [gradientFilter setDefaults];
    CIVector *startVector = [CIVector vectorWithX:size.width/2 Y:0];
    CIVector *endVector = [CIVector vectorWithX:size.width/2 Y:size.height];
    [gradientFilter setValue:startVector forKey:@"inputPoint0"];
    [gradientFilter setValue:endVector forKey:@"inputPoint1"];
    [gradientFilter setValue:bottomColor forKey:@"inputColor0"];
    [gradientFilter setValue:topColor forKey:@"inputColor1"];
    CGImageRef cgimg = [coreImageContext createCGImage:[gradientFilter outputImage]
                                              fromRect:CGRectMake(0, 0, size.width, size.height)];
    return [SKTexture textureWithImage:[UIImage imageWithCGImage:cgimg]];
}

@end
