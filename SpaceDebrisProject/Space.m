//
//  Space.m
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 8. 30..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import "Space.h"
#import "MyConst.h"

@interface Space () {
    SKSpriteNode *_farBG;
    SKSpriteNode *_middleBG_1;
    SKSpriteNode *_middleBG_2;
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
    _farBG.zPosition = BG_FAR;
    _middleBG_1 = [SKSpriteNode spriteNodeWithImageNamed:@"2_background.png"];
    [_middleBG_1 setPosition:position];
    [_middleBG_1 setScale:0.5];
    _middleBG_1.zPosition = BG_MIDDLE;
    _middleBG_2 = [SKSpriteNode spriteNodeWithImageNamed:@"2_background.png"];
    [_middleBG_2 setPosition:CGPointMake(_middleBG_1.position.x+_middleBG_1.size.width, _middleBG_1.position.y)];
    [_middleBG_2 setScale:0.5];
    _middleBG_2.zPosition = BG_MIDDLE;
    _nearBG = [SKSpriteNode spriteNodeWithImageNamed:@"3_background.png"];
    [_nearBG setPosition:position];
    [_nearBG setScale:0.5];
    _nearBG.zPosition = BG_NEAR;
    
    [self addChild:_farBG];
    [self addChild:_middleBG_1];
    [self addChild:_middleBG_2];
    [self addChild:_nearBG];
    
    return self;
}

-(void)setRotation:(CGFloat)rotation {
    //_farBG.zRotation += rotation * 0.00005;
    //_middleBG.zRotation += rotation * 0.0001;
    _nearBG.zRotation += rotation * 0.0005;
}

-(void)update {
    //TODO : infinite scrolling
    _middleBG_1.position = CGPointMake(_middleBG_1.position.x-0.1, _middleBG_1.position.y);
    if (_middleBG_1.position.x <= -_middleBG_1.size.width) {
        [_middleBG_1 setPosition:CGPointMake(_middleBG_2.position.x+_middleBG_2.size.width, _middleBG_2.position.y)];
    }
    _middleBG_2.position = CGPointMake(_middleBG_2.position.x-0.1, _middleBG_2.position.y);
    if (_middleBG_2.position.x <= -_middleBG_2.size.width) {
        [_middleBG_2 setPosition:CGPointMake(_middleBG_1.position.x+_middleBG_1.size.width, _middleBG_1.position.y)];
    }
}


@end
