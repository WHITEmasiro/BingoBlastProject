//
//  ViewController.m
//  GuessNumberPVP
//
//  Created by 黃彥程 on 2016/4/6.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import "ViewController.h"
#import "GassuNumberAI.h"
#import "GuessNumberHost.h"
#import "GameKitHelper.h"
#import "GameCenter.h"
#import <GameKit/GameKit.h>

@interface ViewController () <GKMatchDelegate,GKMatchmakerViewControllerDelegate>
{
    GuessNumberHost * host;
    GassuNumberAI * ai;
    GameCenter * gameCenter;
    NSInteger roundNumber;
    NSArray * friendArray;
    GKMatch * gameMatch;
}
@property (weak, nonatomic) IBOutlet UITextField *inputerNumber;
@property (weak, nonatomic) IBOutlet UITextView *showResult;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    host = [GuessNumberHost new];
    ai = [GassuNumberAI new];
    gameCenter = [GameCenter new];
    [gameCenter authenticate:self];
//    self.delegate = self;
    roundNumber = 0;
    self.inputerNumber.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkBtn:(id)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSString * userGuess = self.inputerNumber.text;
    NSString * resultCheck = [host userGuess:userGuess];
    
    if ([host isValidNumber:userGuess] == false ) {
        
        NSString * hintString = [NSString stringWithFormat:@"%@ 是無效輸入",userGuess];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"請輸入四個不同的數字" message:hintString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
        
    } else {
        roundNumber++;
        NSString * round = [NSString stringWithFormat:@"%li",(long)roundNumber];
        self.showResult.text = [self.showResult.text stringByAppendingString:@"\n"];
        self.showResult.text = [self.showResult.text stringByAppendingString:@"Round: "];
        self.showResult.text = [self.showResult.text stringByAppendingString:round];
        self.showResult.text = [self.showResult.text stringByAppendingString:@"\n"];
        self.showResult.text = [self.showResult.text stringByAppendingString:@"User Guess:"];
        self.showResult.text = [self.showResult.text stringByAppendingString:userGuess];
        self.showResult.text = [self.showResult.text stringByAppendingString:@" ==> "];
        self.showResult.text = [self.showResult.text stringByAppendingString:resultCheck];
        
        NSString * aiGuess = [ai comGuessNumber];
        NSString * airesultCheck = [host userGuess:aiGuess];
        
        if ([host isValidNumber:aiGuess] == false ) {
            self.showResult.text = [NSString stringWithFormat:@"AI Give UP,Please Reset!"];
        } else {
            self.showResult.text = [self.showResult.text stringByAppendingString:@"\n"];
            self.showResult.text = [self.showResult.text stringByAppendingString:@"    AI  Guess:xxxx"];
            //        self.showResult.text = [self.showResult.text stringByAppendingString:aiGuess];
            self.showResult.text = [self.showResult.text stringByAppendingString:@" ==> "];
            self.showResult.text = [self.showResult.text stringByAppendingString:airesultCheck];
            
        }
        
        if ([[host userGuess:userGuess] isEqualToString:@"4A,0B"]) {
            self.showResult.text = [NSString stringWithFormat:@"User Guess: %@, User WIN!",userGuess];
        } else if ([[host userGuess:aiGuess] isEqualToString:@"4A,0B"]) {
            self.showResult.text = [NSString stringWithFormat:@"AI Guess: %@, AI WIN!",aiGuess];
        }
        
        [ai aiGetCheckResult:[host userGuess:aiGuess]];
        [ai comDelNumber];
    }

}

- (IBAction)resetBtn:(id)sender {
    self.showResult.text = nil;
    self.inputerNumber.text = nil;
    host = [GuessNumberHost new];
    ai = [GassuNumberAI new];
    roundNumber = 0;
}

- (IBAction)gamecentetBtn:(id)sender {
    friendArray = [NSArray new];
    [gameCenter invitematch:self group:friendArray];
}

- (IBAction)matchBtn:(id)sender {
    [gameCenter randmatch:self];
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmaker * matchmaker = [GKMatchmaker sharedMatchmaker];
    [matchmaker findMatchForRequest:request withCompletionHandler:^(GKMatch * _Nullable match, NSError * _Nullable error) {
        if (!error) {
            gameMatch = match;
            gameMatch.delegate = self;
        }
    }];
}


#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [self dismissViewControllerAnimated:true completion:nil];
     NSLog(@"Cancal Match!");
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [self dismissViewControllerAnimated:true completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [self dismissViewControllerAnimated:YES completion:nil];
    gameMatch = match; // Use a retaining property to retain the match.
    match.delegate = self;
    NSLog(@"Match is Success!");
//    if (!self.matchStarted && match.expectedPlayerCount == 0)
//    {
//        self.matchStarted = YES;
//        // Insert game-specific code to start the match.
//    }
}

#pragma mark GKMatchDelegate
-(void)match:(GKMatch *)match didFailWithError:(NSError *)error {
    
    NSLog(@"MATCH FAILED: %@", [error description]);
}

-(void)match:(GKMatch *)match player:(GKPlayer *)player didChangeConnectionState:(GKPlayerConnectionState)state {
    
    if (state == GKPlayerStateConnected) {
        gameMatch = match;
    }else if (state == GKPlayerStateDisconnected){
        NSLog(@"Player is Exit!");
    }
    
    
}





@end
