//
//  Player.h
//  HelloBingo
//
//  Created by WHITEer on 2016/03/26.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"

@interface Player : NSObject

@property NSString* name;
@property NSString* photoPath;
@property Board* board;
@property int score;
@property int penalty;

- (instancetype) initWithName:(NSString*)name Photo:(NSString*)photoPath;
- (int) caculateScore;
@end
