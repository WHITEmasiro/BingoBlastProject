//
//  GuessBase.h
//  HomeWorkGuessNumber
//
//  Created by 黃彥程 on 2016/3/28.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuessBase : NSObject

@property NSInteger maxNumber;
@property BOOL allowDuplicateNumbers;

-(BOOL)isValidNumber:(NSString*)input;

-(NSString *)checkAB:(NSString *)answerInput test:(NSString*)testInput;

@end
