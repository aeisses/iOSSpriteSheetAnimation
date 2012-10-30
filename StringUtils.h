//
//  StringUtils.h
//  OutlawVideoPoker
//
//  Created by Aaron Eisses on 11-11-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
-(CGRect)stringToRect;
-(CGPoint)stringToPoint;
+(NSString *)padZerosToInt:(int)_value;
@end