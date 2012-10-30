//
//  CharacterAnimationLayer.h
//  RatherOddJourney
//
//  Created by Aaron Eisses on 12-01-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

// This is important, you must define the framerate of your animation here
#define framerate 30

@protocol SpriteSheetAnimationLayerDelegate <NSObject>
-(void)animationOver:(NSString *)_animation;
@end

@interface SpriteSheetAnimationLayer : CALayer
{
    NSDictionary *myAnimationPlist;
    NSString *animationName;
    unsigned int sampleIndex;
    unsigned int movementIndex;
    BOOL isMovement;
    BOOL sizeInHalf;
    BOOL isMovementNegative;
    int movementAmount;
    int movementFlip;
    CGRect startingRect;
    CGPoint startingPoint;
    NSString *fileName;
    id <CharacterAnimationLayerDelegate> myDelegate;
}

@property (readwrite, nonatomic) unsigned int sampleIndex;
@property (readwrite, nonatomic) unsigned int movementIndex;
@property (retain, nonatomic) id <SpriteSheetAnimationLayerDelegate> myDelegate;

-(id)initWithFile:(NSString *)fileName;
-(id)initWithFile:(NSString *)fileName atLocation:(CGPoint)_location sizeInHalf:(BOOL)_sizeInHalf;
-(void)startAnimation:(int)frames repeatCount:(int)_repeatCount atLocation:(CGPoint)_location withKey:(NSString *)key;
-(void)startMovementAnimation:(int)frames repeatCount:(int)_repeatCount movement:(int)_movement withReverse:(BOOL)isReverse isNegative:(BOOL)_isNegative withKey:(NSString *)key;
-(void)startAnimation:(int)frames repeatCount:(int)_repeatCount withReverse:(BOOL)isReverse withKey:(NSString *)key;
-(void)removeMyAnimations:(NSString *)_key;

@end
