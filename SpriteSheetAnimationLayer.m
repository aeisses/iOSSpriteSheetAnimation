//
//  SpriteSheetAnimationLayer.m
//  RatherOddJourney
//
//  Created by Aaron Eisses on 12-01-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpriteSheetAnimationLayer.h"
#import "StringUtils.h"

@implementation SpriteSheetAnimationLayer

@synthesize sampleIndex;
@synthesize movementIndex;
@synthesize myDelegate;

-(id)initWithFile:(NSString *)_fileName
{
    if (self = [super init]) {
        fileName = [[NSString alloc] initWithString:_fileName];
        NSString *imageString = [[NSString alloc] initWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:fileName ofType:@"png"]];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageString];
        self.contents = (id)image.CGImage;

        NSDictionary *plistData;   
        NSString *localizedPath = [[NSString alloc] initWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]];
        plistData = [[NSDictionary alloc] initWithContentsOfFile:localizedPath];
        myAnimationPlist = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)[plistData objectForKey:@"frames"]];
        animationName = [[NSString alloc] initWithString:fileName];
        
        NSString *dictKey = [[NSString alloc] initWithFormat:@"%@%@.png",fileName,[NSString padZerosToInt:1]];
        NSDictionary *tempDictionary = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)[myAnimationPlist objectForKey:dictKey]];
        CGRect locationFrame = [(NSString *)[tempDictionary objectForKey:@"frame"] stringToRect];
        CGRect sourceColoRect = [(NSString *)[tempDictionary objectForKey:@"sourceColorRect"] stringToRect];
        
        CGSize normalizedSize = CGSizeMake( locationFrame.size.width/CGImageGetWidth(image.CGImage), locationFrame.size.height/CGImageGetHeight(image.CGImage) );
        startingRect = CGRectMake(sourceColoRect.origin.x,
                                  sourceColoRect.origin.y,
                                  sourceColoRect.size.width,
                                  sourceColoRect.size.height);
        
        self.contentsRect = CGRectMake(locationFrame.origin.x/CGImageGetWidth(image.CGImage),
                                       locationFrame.origin.y/CGImageGetWidth(image.CGImage),
                                       normalizedSize.width, normalizedSize.height);
    }
    return self;
}

-(id)initWithFile:(NSString *)_fileName atLocation:(CGPoint)_location sizeInHalf:(BOOL)_sizeInHalf
{
    if (self = [super init]) {
        sizeInHalf = _sizeInHalf;
        startingPoint = _location;
        fileName = [[NSString alloc] initWithString:_fileName];
        NSString *imageString = [[NSString alloc] initWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:fileName ofType:@"png"]];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageString];
        self.contents = (id)image.CGImage;
        
        NSDictionary *plistData;   
        NSString *localizedPath = [[NSString alloc] initWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]];
        plistData = [[NSDictionary alloc] initWithContentsOfFile:localizedPath];
        myAnimationPlist = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)[plistData objectForKey:@"frames"]];
        animationName = [[NSString alloc] initWithString:fileName];
        
        NSString *dictKey = [[NSString alloc] initWithFormat:@"%@%@.png",fileName,[NSString padZerosToInt:1]];
        NSDictionary *tempDictionary = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)[myAnimationPlist objectForKey:dictKey]];
        CGRect locationFrame = [(NSString *)[tempDictionary objectForKey:@"frame"] stringToRect];
        CGRect sourceColoRect = [(NSString *)[tempDictionary objectForKey:@"sourceColorRect"] stringToRect];
        if (sizeInHalf) {
            startingRect = CGRectMake(_location.x+sourceColoRect.origin.x,
                                      _location.y+sourceColoRect.origin.y,
                                      sourceColoRect.size.width*0.5,
                                      sourceColoRect.size.height*0.5);
        } else {
            startingRect = CGRectMake(_location.x+sourceColoRect.origin.x,
                                      _location.y+sourceColoRect.origin.y,
                                      sourceColoRect.size.width,
                                      sourceColoRect.size.height);
        }
        self.frame = startingRect;
        
        CGSize normalizedSize = CGSizeMake( locationFrame.size.width/CGImageGetWidth(image.CGImage), locationFrame.size.height/CGImageGetHeight(image.CGImage) );
        self.contentsRect = CGRectMake(locationFrame.origin.x/CGImageGetWidth(image.CGImage),
                                       locationFrame.origin.y/CGImageGetWidth(image.CGImage),
                                       normalizedSize.width, normalizedSize.height);
    }
    return self;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [myDelegate animationOver:fileName];
}

-(void)startAnimation:(int)frames repeatCount:(int)_repeatCount atLocation:(CGPoint)_location withKey:(NSString *)key
{
    startingPoint = _location;
    self.frame = CGRectMake(_location.x+self.frame.origin.x,
                            _location.y+self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
    
    anim.fromValue = [NSNumber numberWithInt:1]; // initial frame
    anim.toValue = [NSNumber numberWithInt:frames + 1]; // last frame + 1
    
    anim.duration = (float)frames/framerate; // from the first frame to the 6th one in 1 second
    anim.repeatCount = _repeatCount; // just keep repeating it
    anim.delegate = self;
    anim.autoreverses = NO;
    startingRect = self.frame;
    
    [self addAnimation:anim forKey:key]; // start
}

-(void)startMovementAnimation:(int)frames repeatCount:(int)_repeatCount movement:(int)_movement withReverse:(BOOL)isReverse isNegative:(BOOL)_isNegative withKey:(NSString *)key
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"movementIndex"];
    
    anim.fromValue = [NSNumber numberWithInt:0];
    anim.toValue = [NSNumber numberWithInt:_movement];
    
    anim.duration = (float)frames/framerate;
    anim.repeatCount = _repeatCount;
    isMovementNegative = _isNegative;
//    anim.delegate = self;
    anim.autoreverses = isReverse;
    
    [self addAnimation:anim forKey:key];
}

-(void)startAnimation:(int)frames repeatCount:(int)_repeatCount withReverse:(BOOL)isReverse withKey:(NSString *)key
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
    
    anim.fromValue = [NSNumber numberWithInt:1]; // initial frame
    anim.toValue = [NSNumber numberWithInt:frames + 1]; // last frame + 1
    
    anim.duration = (float)frames/framerate; // from the first frame to the 6th one in 1 second
    anim.repeatCount = _repeatCount; // just keep repeating it
    anim.delegate = self;
    anim.autoreverses = isReverse;
    startingRect = self.frame;
    
    [self addAnimation:anim forKey:key]; // start
}

-(void)removeMyAnimations:(NSString *)_key
{
    [self removeAnimationForKey:_key];
    ((CharacterAnimationLayer*)[self presentationLayer]).sampleIndex = 1;
}

+ (BOOL)needsDisplayForKey:(NSString *)key;
{
    return [key isEqualToString:@"sampleIndex"] || [key isEqualToString:@"movementIndex"];
}

+ (id < CAAction >)defaultActionForKey:(NSString *)aKey;
{
    if ([aKey isEqualToString:@"contentsRect"] || [aKey isEqualToString:@"position"] || [aKey isEqualToString:@"bounds"])
        return (id < CAAction >)[NSNull null];
    
    return [super defaultActionForKey:aKey];
}

-(void)display
{
    unsigned int currentSampleIndex = ((CharacterAnimationLayer*)[self presentationLayer]).sampleIndex;
    unsigned int movementSampleIndex = ((CharacterAnimationLayer*)[self presentationLayer]).movementIndex;
    
    if (currentSampleIndex) {    
        NSString *dictKey = [[NSString alloc] initWithFormat:@"%@%@.png",animationName,[NSString padZerosToInt:currentSampleIndex]];
        NSDictionary *tempDictionary = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)[myAnimationPlist objectForKey:dictKey]];
        CGRect myPlistRect = [(NSString *)[tempDictionary objectForKey:@"frame"] stringToRect];
        CGRect m_frame = [(NSString *)[tempDictionary objectForKey:@"sourceColorRect"] stringToRect];    

        CGRect myTempRect = CGRectMake(myPlistRect.origin.x/CGImageGetWidth((CGImageRef)self.contents), 
                                       myPlistRect.origin.y/CGImageGetHeight((CGImageRef)self.contents), 
                                       myPlistRect.size.width/CGImageGetWidth((CGImageRef)self.contents),
                                       myPlistRect.size.height/CGImageGetHeight((CGImageRef)self.contents));

        self.contentsRect = myTempRect;
        if (sizeInHalf) {
            self.frame = CGRectMake(startingPoint.x+m_frame.origin.x,
                                    startingPoint.y+m_frame.origin.y,
                                    m_frame.size.width*0.5,
                                    m_frame.size.height*0.5);
        } else {
            self.frame = CGRectMake(startingPoint.x+m_frame.origin.x,
                                    startingPoint.y+m_frame.origin.y,
                                    m_frame.size.width,
                                    m_frame.size.height);
        }
    }
    if (movementSampleIndex) {
        if (isMovementNegative) {
            self.frame = CGRectMake(self.frame.origin.x, startingPoint.y - movementSampleIndex, self.frame.size.width, self.frame.size.height);
        } else {
            self.frame = CGRectMake(self.frame.origin.x, startingPoint.y + movementSampleIndex, self.frame.size.width, self.frame.size.height);
        }
    }
}

@end
