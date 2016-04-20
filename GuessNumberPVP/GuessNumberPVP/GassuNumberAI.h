//
//  GassuNumberAI.h
//  HomeWorkGuessNumber
//
//  Created by 黃彥程 on 2016/3/29.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import "GuessBase.h"

@interface GassuNumberAI : GuessBase

-(NSString*)comGuessNumber;
-(NSMutableArray*)comDelNumber;
-(void)aiGetCheckResult:(NSString*)airesult;
@end
