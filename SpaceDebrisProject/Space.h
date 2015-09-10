//
//  Space.h
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 8. 30..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MyNode.h"

@interface Space : SKNode<MyNode>

@property(nonatomic) CGFloat rotation;

+ (instancetype)sharedInstanceWithPosition:(CGPoint)position;

@end
