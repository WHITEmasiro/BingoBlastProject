//
//  ViewController.h
//  HelloBingo
//
//  Created by WHITEer on 2016/03/26.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "BlockButton.h"
#import "Player.h"
#import "Board.h"
#import "CallNumbers.h"

#define CALL_NUMBER_TIME_INTERVAL 2 //unit is second. 2 may be used.

@interface GameViewController : UIViewController
{
    //    Board* board;
    Player* player;
    UIView* boardView;
    BlockButton* blockButtons[LINE_LENGTH][LINE_LENGTH];
    UIImageView* drawBoardView;//used to draw line...
    __weak IBOutlet UILabel *scoreLabel;
    
    Player* opponent;
    UIView* opponentBoardView;
    __weak IBOutlet UILabel *opponentScoreLabel;
    UIImageView* drawOpponentBoardView;//used to draw line...
    
    CallNumbers* callNumbers;
    UIView* callNumberView;
    UILabel* callNumberLabels[CALL_NUMBER_COUNT];
    NSTimer* callNumberTimer;
    
    AVAudioPlayer* bgmPlayer;
    __weak IBOutlet UILabel *bgmAuthor;
    //    __weak IBOutlet UILabel *bgmAuthorWeb;
    AVAudioPlayer* blockClickedSoundPlayer;
    BOOL isMuted;
    
    BOOL isOver;
}

- (void)updateGame;
- (void) backToMenu:(id)sender;
- (void)gameOver;

@end

