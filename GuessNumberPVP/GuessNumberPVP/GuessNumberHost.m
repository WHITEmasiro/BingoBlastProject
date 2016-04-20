//
//  GuessNumberHost.m
//  HomeWorkGuessNumber
//
//  Created by 黃彥程 on 2016/3/28.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import "GuessNumberHost.h"

@interface GuessNumberHost()
{
    NSString * appNumberString;
    
}

@end

@implementation GuessNumberHost
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self randNumber];
    }
    return self;
}

-(void)randNumber {
    
    NSMutableArray * randArray = [NSMutableArray new];
    
    do {
        int randint = arc4random() %10;
        
        NSString * randString = [NSString stringWithFormat:@"%i",randint];
        
        if ([randArray indexOfObject:randString] == NSNotFound) {
            [randArray addObject:randString];
        }
        
    }while (randArray.count < self.maxNumber );
    
    appNumberString = [randArray componentsJoinedByString:@""];
    NSLog(@"Answer: %@",appNumberString);
}

-(NSString*)userGuess:(NSString*)userInput {
    
    NSString * userguess = [self checkAB:appNumberString test:userInput];
    
    return userguess;
    
}

@end
