//
//  Satellite.h
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 6. 16..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MyNode.h"

@interface Satellite : SKNode <MyNode>

@property (nonatomic) CGFloat beamLength;
@property (nonatomic) BOOL shoot;
@property (nonatomic) CGFloat battery;
@property (nonatomic) CGFloat energyDrain;

-(instancetype)initWithPosition:(CGPoint)position;

@end
