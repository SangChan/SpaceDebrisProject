//
//  MyConst.h
//  SpaceDebrisProject
//
//  Created by SangChan on 2015. 6. 25..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#ifndef SpaceDebrisProject_MyConst_h
#define SpaceDebrisProject_MyConst_h

#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)
static const uint32_t NO_ONE    = 0x1 << 0;
static const uint32_t PLANET    = 0x1 << 1;
static const uint32_t SATELLITE = 0x1 << 2;
static const uint32_t DEBRIS    = 0x1 << 3;
static const uint32_t GOLD      = 0x1 << 4;


#endif

static inline CGPoint ccp( CGFloat x, CGFloat y )
{
    return CGPointMake(x, y);
}
static inline CGPoint ccpSub(const CGPoint v1, const CGPoint v2)
{
    return ccp(v1.x - v2.x, v1.y - v2.y);
}
static inline CGPoint ccpMult(const CGPoint v, const CGFloat s)
{
    return ccp(v.x*s, v.y*s);
}
static inline CGFloat ccpDot(const CGPoint v1, const CGPoint v2)
{
    return v1.x*v2.x + v1.y*v2.y;
}

static inline CGFloat ccpLengthSQ(const CGPoint v)
{
    return ccpDot(v, v);
}

static inline CGFloat ccpLength(const CGPoint v)
{
    return sqrtf(ccpLengthSQ(v));
}

static inline CGFloat ccpDistance(const CGPoint v1, const CGPoint v2)
{
    return ccpLength(ccpSub(v1, v2));
}

static inline CGPoint ccpNormalize(CGPoint vector)
{
    CGFloat length = sqrt(vector.x*vector.x +vector.y*vector.y);
    if (length < FLT_EPSILON)
    {
        return vector;
    }
    CGFloat invLength = 1.0f / length;
    vector.x *= invLength;
    vector.y *= invLength;
    
    return vector;
}

