//
//  GameKitHelper.h
//  GuessNumberPVP
//
//  Created by 黃彥程 on 2016/4/6.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GameKitHelperProtocol<NSObject>
@end

@interface GameKitHelper : NSObject

@property (nonatomic, weak) id<GameKitHelperProtocol> delegate;

@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;

-(void) authenticateLocalPlayer;

@end
