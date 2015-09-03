//
//  Space.h
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 8. 30..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Space : SKNode

@property(nonatomic) CGFloat rotation;

+ (instancetype)sharedInstanceWithPosition:(CGPoint)position;

@end
