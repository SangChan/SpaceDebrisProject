//
//  Satellite.h
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 6. 16..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MyNode.h"

@interface Satellite : SKSpriteNode <MyNode>

@property (nonatomic) BOOL shoot;
@property (nonatomic) int battery;
@end
