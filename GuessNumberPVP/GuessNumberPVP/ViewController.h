//
//  ViewController.h
//  GuessNumberPVP
//
//  Created by 黃彥程 on 2016/4/6.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ViewController : UIViewController

@property(nonatomic, assign) id< GKMatchDelegate > delegate;
@end

