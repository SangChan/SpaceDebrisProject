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

+ (instancetype)sharedInstance {
    static Space *sharedMySpace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMySpace = [[super alloc] initSpace];
    });
    return sharedMySpace;
}

-(instancetype)initSpace {
    self = [self init];
    if (!self) return nil;
    
    _farBG = [SKSpriteNode spriteNodeWithImageNamed:@"1_background.png"];
    _middleBG = [SKSpriteNode spriteNodeWithImageNamed:@"2_background.png"];
    _nearBG = [SKSpriteNode spriteNodeWithImageNamed:@"3_background.png"];
    
    [self addChild:_farBG];
    [self addChild:_middleBG];
    [self addChild:_nearBG];
    
    return self;
}


@end
