//
//  ViewController.m
//  HelloBingo
//
//  Created by WHITEer on 2016/03/26.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundColor"]]];
    
    [self setBackgroundOfView:self.view WithImageNamed:@"BackgroundColor"];
    
    isOver = false;
    
    player = [[Player alloc] initWithName:@"tempName" Photo:@"tempPath"];
    [self createBoard];
    
    opponent = [[Player alloc] initWithName:@"tempName" Photo:@"tempPath"];
    [self createOpponentBoard];

    [self createCallNumbers];
    callNumberTimer = [NSTimer scheduledTimerWithTimeInterval:CALL_NUMBER_TIME_INTERVAL target:self selector:@selector(callNewNumber) userInfo:nil repeats:YES];
    
    [self playBgm];

}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - sound,music,voice access

- (void) playBgm{
    
    NSURL* bgmFile = [[NSBundle mainBundle] URLForResource:@"bgm/kouchanojikan" withExtension:@"mp3"];
    bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgmFile error:nil];
    bgmPlayer.numberOfLoops = -1;
    [bgmPlayer play];
    [self.view bringSubviewToFront:bgmAuthor];
//    [self.view bringSubviewToFront:bgmAuthorWeb];
    
}

- (IBAction) muteButtonPressed:(id)sender {
    
    UIButton* muteButton = (UIButton*)sender;
    if(isMuted){
        [bgmPlayer setVolume:1.0];
        [blockClickedSoundPlayer setVolume:1.0];
        [muteButton setImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
    }
    else{
        [bgmPlayer setVolume:0.0];
        [blockClickedSoundPlayer setVolume:0.0];
        [muteButton setImage:[UIImage imageNamed:@"muteVolume"] forState:UIControlStateNormal];
    }
    
    isMuted = !isMuted;
       
}

#pragma mark - player's board access

- (void) createBoard{
    
//    board = [[Board alloc]init];
    
    CGSize screenSize = self.view.frame.size;
    //    CGRect boardViewFrame = CGRectMake(0, screenSize.height - screenSize.width, screenSize.width, screenSize.width);
        CGRect boardViewFrame = CGRectMake(0, screenSize.height / 2, screenSize.width, screenSize.height / 2);
    
    boardView = [[UIView alloc] initWithFrame:boardViewFrame];
    
//    int block_width = boardView.frame.size.width/LINE_LENGTH;
    CGRect boardInsideRect = CGRectMake(screenSize.width * 5.0/320.0 - boardViewFrame.origin.x , screenSize.height * 289.0/568.0 - boardViewFrame.origin.y, screenSize.width * 310.0/320.0, screenSize.height * 274.0/568.0);
    int block_width = boardInsideRect.size.width/LINE_LENGTH;
    int block_height = boardInsideRect.size.height/LINE_LENGTH;
    //create button
    for(int y = 0; y < LINE_LENGTH; y++){
        for(int x = 0; x < LINE_LENGTH; x++){
//                        CGRect blockButtonRect = CGRectMake(x * block_width + block_width * 0.05, y * block_width + block_width * 0.05, block_width * 0.9, block_width * 0.9);
            CGRect blockButtonRect = CGRectMake(boardInsideRect.origin.x + x * block_width + block_width * 0.05, boardInsideRect.origin.y + y * block_height + block_height * 0.05, block_width * 0.9, block_height * 0.9);
            blockButtons[x][y] = [[BlockButton alloc] initWithFrame:blockButtonRect X:x Y:y];
            BlockButton* blockButton = blockButtons[x][y];
            [self setBackgroundOfView:blockButton WithImageNamed:@"NumbersAtBingo"];
            [blockButton setTitle:[NSString stringWithFormat:@"%i",[player.board getBlockX:x Y:y].number] forState:UIControlStateNormal];
            [blockButton addTarget:self action:@selector(blockPressed:) forControlEvents:UIControlEventTouchUpInside];
            [boardView addSubview:blockButton];
        }
    }
    
    //clear background color
//    [boardView setBackgroundColor:nil];
    [self setBackgroundOfView:boardView WithImageNamed:@"BingoNumberBackground"];
    [self.view addSubview:boardView];
    
    //add drawBoardView
    drawBoardView = [[UIImageView alloc] initWithFrame:boardViewFrame];
    [drawBoardView setAlpha:0.5];
//    [drawBoardView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:drawBoardView];
//    [self.view bringSubviewToFront:drawBoardView];

}

- (void) blockPressed:(BlockButton*)sender{
    
    if(isOver)return;
    NSURL* blockClickedSoundFile = nil;
    Block* block = [player.board getBlockX:sender.x Y:sender.y];
    
    if(block.isChecked){
        blockClickedSoundFile = [[NSBundle mainBundle] URLForResource:@"sound/decision22" withExtension:@"mp3"];
    }else{
        int matchIndex = [callNumbers checkNumber:block.number];
        if( matchIndex != -1){
            [callNumbers setNumber:matchIndex to:-1];
            block.isChecked = true;
            blockClickedSoundFile = [[NSBundle mainBundle] URLForResource:@"sound/decision3" withExtension:@"mp3"];
        }else{
            player.penalty += 50;
            blockClickedSoundFile = [[NSBundle mainBundle] URLForResource:@"sound/cancel5" withExtension:@"mp3"];
        }
    }
    if(!isMuted){
        blockClickedSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:blockClickedSoundFile error:nil];
        [blockClickedSoundPlayer play];
    }
    
    [self updateGame];
    
}

- (void) drawBoard{
    
    NSMutableArray* lines = [player.board checkLines];
    
    UIGraphicsBeginImageContext(drawBoardView.frame.size);
    int block_width = boardView.frame.size.width/LINE_LENGTH;
    for(int n = 0; n < lines.count; n++){
        
        CGFloat start_x = block_width/2 + ((Line*)[lines objectAtIndex:n]).startPoint.x * block_width;
        CGFloat start_y = block_width/2 + ((Line*)[lines objectAtIndex:n]).startPoint.y * block_width;
        CGFloat end_x = block_width/2 + ((Line*)[lines objectAtIndex:n]).endPoint.x * block_width;
        CGFloat end_y = block_width/2 + ((Line*)[lines objectAtIndex:n]).endPoint.y * block_width;
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), start_x, start_y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), end_x, end_y);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0f);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    drawBoardView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
}

#pragma mark - opponent's board access

- (void) createOpponentBoard{
    
//    int selfViewFrameHeight = self.view.frame.size.height;
//    int selfViewFrameWidth = self.view.frame.size.width;
//    CGRect drawOpponentBoardViewFrame = CGRectMake(selfViewFrameWidth *(LINE_LENGTH-1)/LINE_LENGTH, selfViewFrameHeight -selfViewFrameWidth * (1 + (double)2/LINE_LENGTH), selfViewFrameWidth / LINE_LENGTH, selfViewFrameWidth / LINE_LENGTH);
    CGSize screenSize = self.view.frame.size;
    CGRect drawOpponentBoardViewFrame = CGRectMake(screenSize.width * 226.0/320.0, screenSize.height * 49.0/568.0, screenSize.width * 88.0/320.0, screenSize.height * 88.0/568.0);
    drawOpponentBoardView = [[UIImageView alloc] initWithFrame:drawOpponentBoardViewFrame];
    [drawOpponentBoardView setBackgroundColor:[UIColor darkGrayColor]];
    [drawOpponentBoardView setAlpha:0.5];
    [self.view addSubview:drawOpponentBoardView];
    [self.view bringSubviewToFront:drawOpponentBoardView];
    
}

- (void) drawOpponentBoard{
    
    NSMutableArray* lines = [opponent.board checkLines];
    
    UIGraphicsBeginImageContext(drawOpponentBoardView.frame.size);
    int block_width = round(drawOpponentBoardView.frame.size.width / LINE_LENGTH);
    
    //draw blocks
    for(int y = 0; y < LINE_LENGTH; y++){
        for(int x = 0;x < LINE_LENGTH; x++){
            if([opponent.board getBlockX:x Y:y].isChecked){
                
                CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 255.0/255.0, 102.0/255.0, 0, 1.0);
                CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(x * block_width, y * block_width, block_width, block_width));
                
            }
            
            
        }
    }
    
    //draw lines
    for(int n = 0; n < lines.count; n++){
        
        CGFloat start_x = block_width/2 + ((Line*)[lines objectAtIndex:n]).startPoint.x * block_width;
        CGFloat start_y = block_width/2 + ((Line*)[lines objectAtIndex:n]).startPoint.y * block_width;
        CGFloat end_x = block_width/2 + ((Line*)[lines objectAtIndex:n]).endPoint.x * block_width;
        CGFloat end_y = block_width/2 + ((Line*)[lines objectAtIndex:n]).endPoint.y * block_width;
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), start_x, start_y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), end_x, end_y);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0f);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    drawOpponentBoardView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
}

#pragma mark - called numbers access

- (void) createCallNumbers{
    
    callNumbers = [[CallNumbers alloc] init];
    CGSize screenSize = self.view.frame.size;
//    CGRect callNumberViewFrame = CGRectMake(0, screenSize.height - screenSize.width - screenSize.width * 1/CALL_NUMBER_COUNT, screenSize.width, screenSize.width * 1/CALL_NUMBER_COUNT);
    CGRect callNumberViewFrame = CGRectMake(screenSize.width * 8.0/320.0, screenSize.height * 139.45/568, screenSize.width * 290.0/320.0, screenSize.height * 64.11/568);
    callNumberView = [[UIView alloc] initWithFrame:callNumberViewFrame];
    
    int callNumberLabelWidth = callNumberViewFrame.size.width/CALL_NUMBER_COUNT;
    int callNumberLabelHeight = callNumberViewFrame.size.height;
    
    for(int n = 0; n < CALL_NUMBER_COUNT; n++){
        CGRect callNumberFrame = CGRectMake(n * callNumberLabelWidth, 0, callNumberLabelWidth * 133.0/115.0, callNumberLabelHeight * 133.0/115.0);
        callNumberLabels[n] = [[UILabel alloc] initWithFrame:callNumberFrame];
        UILabel* callNumberLabel = callNumberLabels[n];
        if([callNumbers getNumber:n] != -1){
        
            [self setBackgroundOfView:callNumberLabel WithImageNamed:@"CurrentNumber"];
            NSString* callNumberString = [NSString stringWithFormat:@"%i",[callNumbers getNumber:n]];
            [callNumberLabel setText:callNumberString];
        }//        [callNumberLabel setBackgroundColor:[UIColor yellowColor]];
        callNumberLabel.textAlignment = NSTextAlignmentCenter;
        [callNumberView addSubview:callNumberLabel];
    }
    
    
    [self setBackgroundOfView:callNumberView WithImageNamed:@"Combined Shape"];
//    [callNumberView setBackgroundColor:[UIColor blueColor]];
    [callNumberView setAlpha:0.5];
    [self.view addSubview:callNumberView];
//    [self.view bringSubviewToFront:callNumberView];
    
    
}

- (void) callNewNumber{
    
    [callNumbers turnNumbers];
    [self updateCallNumbers];
    if([callNumbers isNoNumber]){
        [self gameOver];
    }
}

#pragma mark - game update

- (void) updateScore{
    
    [scoreLabel setText:[NSString stringWithFormat:@"score:%i",[player caculateScore]]];
    
}

- (void) updateBoard{
    
    for(int y = 0; y < LINE_LENGTH; y++){
        for(int x = 0; x < LINE_LENGTH; x++){
            BlockButton* blockButton = blockButtons[x][y];
            if([player.board getBlockX:x Y:y].isChecked)[self setBackgroundOfView:blockButton WithImageNamed:@"CheckedNumbersAtBingo"];
            else if([player.board getBlockX:x Y:y].isUnvalid)[blockButton setBackgroundColor:[UIColor redColor]];
            else [self setBackgroundOfView:blockButton WithImageNamed:@"NumbersAtBingo"];
//            else [blockButton setBackgroundColor:[UIColor blackColor]];
            [blockButton setTitle:[NSString stringWithFormat:@"%i",[player.board getBlockX:x Y:y].number] forState:UIControlStateNormal];
        }
    }
    

}

- (void) updateCallNumbers{
    
    for(int n = 0; n < CALL_NUMBER_COUNT; n++){
        UILabel* callNumberLabel = callNumberLabels[n];
        NSString* callNumberString = @"";
        if([callNumbers getNumber:n] != -1){
            callNumberString = [NSString stringWithFormat:@"%i",[callNumbers getNumber:n]];
            [self setBackgroundOfView:callNumberLabel WithImageNamed:@"CurrentNumber"];
        }else{
            [callNumberLabel setBackgroundColor:[UIColor clearColor]];
        }
            [callNumberLabel setText:callNumberString];
    }
    
}

- (void) updateGame{
    
    //must before updateScore
    [self updateBoard];
    [self updateScore];
    [self updateCallNumbers];
    [self drawBoard];
    [self drawOpponentBoard];
    
}

#pragma game over access

- (void) gameOver{
    
    [callNumberTimer invalidate];
    callNumberTimer = nil;
    
    //UIView makes buttons under it unable to be pressed,but UIImage doesn't.
    UIView* gameOverView = [[UIView alloc] initWithFrame:self.view.frame];
    [gameOverView setBackgroundColor:[UIColor blackColor]];
    [gameOverView setAlpha:0.85];
    
    CGRect selfViewFrame = self.view.frame;
    int lineHeight = selfViewFrame.size.height * 0.05;
    int displayTop = (selfViewFrame.size.height - lineHeight * 3) / 2;
    
    UILabel* finalScoreLabel = [[UILabel alloc] init];
    [finalScoreLabel setText:[NSString stringWithFormat:@"你的分數：%i",[player caculateScore]]];
    finalScoreLabel.font = [finalScoreLabel.font fontWithSize:lineHeight];
    [finalScoreLabel setTextColor:[UIColor whiteColor]];
    [finalScoreLabel setShadowColor:[UIColor blackColor]];
    [finalScoreLabel sizeToFit];
    
    CGRect finalScoreLabelFrame = CGRectMake((selfViewFrame.size.width - finalScoreLabel.frame.size.width)/2, displayTop, finalScoreLabel.frame.size.width, finalScoreLabel.frame.size.height);
    finalScoreLabel.frame = finalScoreLabelFrame;
    
    UILabel* finalOpponentScoreLabel = [[UILabel alloc] init];
    [finalOpponentScoreLabel setText:[NSString stringWithFormat:@"對手的分數：%i",[opponent caculateScore]]];
    finalOpponentScoreLabel.font = [finalOpponentScoreLabel.font fontWithSize:lineHeight];
    [finalOpponentScoreLabel setTextColor:[UIColor whiteColor]];
    [finalOpponentScoreLabel setShadowColor:[UIColor blackColor]];
    [finalOpponentScoreLabel sizeToFit];

    
    CGRect finalOpponentScoreLabelFrame = CGRectMake((selfViewFrame.size.width - finalOpponentScoreLabel.frame.size.width)/2, displayTop + lineHeight, finalOpponentScoreLabel.frame.size.width , finalOpponentScoreLabel.frame.size.height);
    finalOpponentScoreLabel.frame = finalOpponentScoreLabelFrame;
    
    //button used to back to menu
    UIButton* backButton = [[UIButton alloc] init];
    [backButton setTitle:@"回選單" forState:UIControlStateNormal];
    backButton.titleLabel.font = [backButton.titleLabel.font fontWithSize:lineHeight];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    backButton.frame = CGRectMake((selfViewFrame.size.width - backButton.frame.size.width)/2, displayTop + lineHeight * 2, backButton.frame.size.width, backButton.frame.size.height);
    
    [self.view addSubview:gameOverView];
    [self.view addSubview:finalScoreLabel];
    [self.view addSubview:finalOpponentScoreLabel];
    [self.view addSubview:backButton];
    
}

- (void) backToMenu:(id)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma screen access

-(bool) shouldAutorotate{
    return false;
}

-(BOOL)prefersStatusBarHidden{
    return true;
}


#pragma access background of view

-(void) setBackgroundOfView:(UIView*)view WithImageNamed:(NSString*)imageName{
    
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
//    NSLog(@"width:%f,height:%f",view.bounds.size.width,view.bounds.size.height);
}

@end
