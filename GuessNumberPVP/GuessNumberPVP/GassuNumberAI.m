//
//  GassuNumberAI.m
//  HomeWorkGuessNumber
//
//  Created by 黃彥程 on 2016/3/29.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import "GassuNumberAI.h"

@interface GassuNumberAI()
{
    NSMutableArray * allNumbersArray;
    NSString * lastComGuess;
    NSString * aiGet;
}


@end

@implementation GassuNumberAI

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self allPossiblities];
    }
    return self;
}


-(void)allPossiblities{
    
    int startNumber = 0;
    int endNumber = 0;
    
    if (self.allowDuplicateNumbers) {
        startNumber = 0;
        for (int i=0; i<=self.maxNumber; i++) {
            endNumber *= 10;
            endNumber += 9;
        }
    } else {
        for (int i=0; i<self.maxNumber; i++) {
            startNumber *= 10;
            startNumber += i;
            
            endNumber *= 10;
            endNumber += 9-i;
        }
    }
    
    NSString * formString = [NSString stringWithFormat:@"%%0%ldd",(long)self.maxNumber];
    allNumbersArray = [NSMutableArray new];
    for (int i =startNumber; i<=endNumber; i++) {
        NSString * tmpString = [NSString stringWithFormat:formString,i];
        
        if ([self isValidNumber:tmpString] == true) {
            [allNumbersArray addObject:tmpString];
            
        }
    }
    
    NSLog(@"Total: %lu",(unsigned long)allNumbersArray.count);
    
}

-(NSString*)comGuessNumber {
    if (allNumbersArray.count == 0) {
        [self allPossiblities];
        NSString * again = [self comGuessNumber];
        
        return again;
    }
    int random = arc4random() %allNumbersArray.count;

    lastComGuess = [allNumbersArray objectAtIndex:random];

    return lastComGuess;
}

-(void)aiGetCheckResult:(NSString*)airesult {
    aiGet = airesult;
    NSLog(@"AI Know: %@",aiGet);
}

-(NSMutableArray*)comDelNumber{
    NSMutableArray * newallNumbersArray = [NSMutableArray new];

    for (NSString * testString in allNumbersArray) {
        if ([[self checkAB:testString test:lastComGuess] isEqualToString:aiGet]) {
            [newallNumbersArray addObject:testString];
        }
    }
    
    allNumbersArray = newallNumbersArray;
    NSLog(@"Total: %lu",(unsigned long)allNumbersArray.count);
    
    return allNumbersArray;
}



@end





