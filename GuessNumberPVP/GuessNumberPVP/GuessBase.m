//
//  GuessBase.m
//  HomeWorkGuessNumber
//
//  Created by 黃彥程 on 2016/3/28.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import "GuessBase.h"

@implementation GuessBase

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxNumber = 4;
        self.allowDuplicateNumbers = false;
    }
    return self;
}

-(BOOL)isValidNumber:(NSString*)input {
    
    NSInteger inputlength = input.length;
    if (inputlength != self.maxNumber) {
        return false;
    }
    
    if (input.integerValue == NSNotFound) {
        return false;
    }
    
    if (self.allowDuplicateNumbers == false) {

        NSMutableArray * testArray = [NSMutableArray new];
        for (int i=0; i<self.maxNumber; i++) {
            NSString * test = [input substringWithRange:NSMakeRange(i, 1)];
            [testArray addObject:test];
            
        }
        NSSet * testset = [[NSSet alloc] initWithArray:testArray];
        if (testset.count != self.maxNumber) {
            return false;
        }
        
    }
    
    return true;
}


-(NSString *)checkAB:(NSString *)answerInput test:(NSString*)testInput {

    if ([self isValidNumber:testInput] == false || [self isValidNumber:answerInput] == false) {
        return nil;
    }
    
    NSMutableArray * testArray = [NSMutableArray new];
    for (int i=0; i<self.maxNumber; i++) {
        NSString * test = [testInput substringWithRange:NSMakeRange(i, 1)];
        [testArray addObject:test];
        
    }
    NSMutableArray * answerArray = [NSMutableArray new];
    for (int i=0; i<self.maxNumber; i++) {
        NSString * answer = [answerInput substringWithRange:NSMakeRange(i, 1)];
        [answerArray addObject:answer];
        
    }
    int resultA = 0;
    int resultB = 0;
    
    for (int i=0; i<self.maxNumber; i++) {
        for (int j=0; j<self.maxNumber; j++) {
            
            if (testArray[i] == answerArray[j] && i==j) {
                resultA++;
            }else if (testArray[i] == answerArray[j]) {
                resultB++;
            }
            
        }
    }
    
    
    NSString * resultString = [NSString stringWithFormat:@"%iA,%iB",resultA,resultB];

    return resultString;
    
}






@end
