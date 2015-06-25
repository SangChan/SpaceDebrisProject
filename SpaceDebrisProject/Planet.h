//
//  Planet.h
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 6. 16..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MyNode.h"
#import "MyConst.h"

@interface Planet : SKNode<MyNode>
@property (nonatomic) CGFloat healthPoint;
@property (nonatomic) CGFloat maxHealthPoint;
@property (nonatomic) CGPoint fixedPosition;
@property (nonatomic) CGFloat fixedRadius;

-(instancetype)initWithPosition:(CGPoint)position Radius:(CGFloat)radius;
-(void)getDamage:(CGFloat)damage;

@end
