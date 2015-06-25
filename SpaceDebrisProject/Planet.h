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

@interface Planet : SKShapeNode<MyNode>
@property (nonatomic) CGPoint fixedPosition;

-(instancetype)initWithPosition:(CGPoint)position;

@end
