//
//  Debris.h
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 6. 16..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MyNode.h"

@interface Debris : SKNode<MyNode> {
}

@property (nonatomic) BOOL active;
@property (nonatomic) CGFloat attackPoint;

-(instancetype)initWithPosition:(CGPoint)position;
-(void)boom_boom_kaboom;

@end
