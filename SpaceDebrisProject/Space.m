//
//  Space.m
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 8. 30..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import "Space.h"

@interface Space () {
    SKSpriteNode *_farBG;
    SKSpriteNode *_middleBG;
    SKSpriteNode *_nearBG;
}

@end

@implementation Space

+ (instancetype)sharedInstanceWithPosition:(CGPoint)position {
    static Space *sharedMySpace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMySpace = [[super alloc] initSpaceWithPosition:position];
    });
    return sharedMySpace;
}

-(instancetype)initSpaceWithPosition:(CGPoint)position {
    self = [self init];
    if (!self) return nil;
    
    _farBG = [SKSpriteNode spriteNodeWithImageNamed:@"1_background.png"];
    [_farBG setPosition:position];
    [_farBG setScale:0.5];
    _middleBG = [SKSpriteNode spriteNodeWithImageNamed:@"2_background.png"];
    [_middleBG setPosition:position];
    [_middleBG setScale:0.5];
    _nearBG = [SKSpriteNode spriteNodeWithImageNamed:@"3_background.png"];
    [_nearBG setPosition:position];
    [_nearBG setScale:0.5];
    
    [self addChild:_farBG];
    [self addChild:_middleBG];
    [self addChild:_nearBG];
    
    return self;
}

-(void)setRotation:(CGFloat)rotation {
    _middleBG.zRotation += rotation * 0.0001;
    _nearBG.zRotation += rotation * 0.0005;
}


@end
