//
//  Block.m
//  HelloBingo
//
//  Created by WHITEer on 2016/03/27.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "Block.h"

@implementation Block

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.isChecked = false;
        self.number = 1;
        
    }
    return self;
}

@end
