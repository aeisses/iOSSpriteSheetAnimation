//
//  StringUtils.m
//  OutlawVideoPoker
//
//  Created by Aaron Eisses on 11-11-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StringUtils.h"

@implementation NSString (Utils)

// Add the commas to the string and return the string
-(CGRect)stringToRect
{    
    NSString *tempString = [self stringByReplacingOccurrencesOfString:@"{" withString:@""];
    NSString *curllyBracesRemove = [tempString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    NSArray *rectArray = [NSArray arrayWithArray:[curllyBracesRemove componentsSeparatedByString:@","]];
    
    if ([rectArray count] != 4) {
        return CGRectMake(0, 0, 0, 0);
    }
    // Return the created string
    return CGRectMake([(NSString *)[rectArray objectAtIndex:0] floatValue],
                      [(NSString *)[rectArray objectAtIndex:1] floatValue],
                      [(NSString *)[rectArray objectAtIndex:2] floatValue],
                      [(NSString *)[rectArray objectAtIndex:3] floatValue]);
}

-(CGPoint)stringToPoint
{
    NSString *tempString = [self stringByReplacingOccurrencesOfString:@"{" withString:@""];
    NSString *curllyBracesRemove = [tempString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    NSArray *pointArray = [NSArray arrayWithArray:[curllyBracesRemove componentsSeparatedByString:@","]];
    
    if ([pointArray count] != 2) {
        return CGPointMake(0, 0);
    }
    
    // Return the created string
    return CGPointMake([(NSString *)[pointArray objectAtIndex:0] floatValue],
                       [(NSString *)[pointArray objectAtIndex:1] floatValue]);
}

+(NSString *)padZerosToInt:(int)_value
{
    if (_value < 10) {
        return [NSString stringWithFormat:@"000%i",_value];
    } else if (_value < 100) {
        return [NSString stringWithFormat:@"00%i",_value];
    } else if (_value < 1000) {
        return [NSString stringWithFormat:@"0%i",_value];
    }
    return [NSString stringWithFormat:@"%i",_value];
}

@end
