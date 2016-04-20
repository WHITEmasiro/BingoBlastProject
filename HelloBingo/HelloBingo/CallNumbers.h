//
//  callNumbers.h
//  HelloBingo
//
//  Created by WHITEer on 2016/04/06.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CALL_NUMBER_COUNT 5
#define ALL_NUMBER_COUNT 75

@interface CallNumbers : NSObject

@property NSMutableArray* allNumbers;

- (void) turnNumbers;
- (int) getNumber:(int)index;
- (void) setNumber:(int)index to:(int)number;
- (int) checkNumber:(int)checkedNumber;
- (BOOL) isNoNumber;

@end
