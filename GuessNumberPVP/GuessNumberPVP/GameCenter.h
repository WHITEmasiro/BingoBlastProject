//
//  GameCenter.h
//  GuessNumberPVP
//
//  Created by 黃彥程 on 2016/4/8.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCenter : NSObject

@property (nonatomic,assign) BOOL gameCenterAvailabled;
-(void) authenticate:(id)sender;
-(void) randmatch:(id)sender;
-(void) invitematch:(id)sender  group:(NSArray*) friends;
@end
