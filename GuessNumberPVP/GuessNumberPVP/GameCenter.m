//
//  GameCenter.m
//  GuessNumberPVP
//
//  Created by 黃彥程 on 2016/4/8.
//  Copyright © 2016年 cheng. All rights reserved.
//

#import "GameCenter.h"
#import <GameKit/GameKit.h>

@interface GameCenter()
{
    GKMatch *gameMatch;
}

@end

@implementation GameCenter

-(void) authenticate:(id)sender {
    
    GKLocalPlayer * locPlayer = [GKLocalPlayer localPlayer];
    
    locPlayer.authenticateHandler = ^(UIViewController *viewController,
                                    NSError *error) {
        if (viewController != nil)
        {
            [sender presentViewController:viewController animated:true completion:nil];
        }
        if ([GKLocalPlayer localPlayer].isAuthenticated) {
            self.gameCenterAvailabled = true;
            
        } else {
            self.gameCenterAvailabled = false;
        }
        
    };
}


-(void) randmatch:(id)sender {
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = sender;
    
    [sender presentViewController:mmvc animated:YES completion:nil];
}

-(void)invitematch:(id)sender group:(NSArray*) friends {
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    request.recipients = friends;
    request.inviteMessage = @"Do you want to Play?";
    request.recipientResponseHandler= ^(GKPlayer *player, GKInviteeResponse response)
    {
        
        NSLog(@"response Get From Other User.");
        
        switch (response) {
            case GKInviteeResponseAccepted:
            {
                NSLog(@"GKInviteeResponseAccepted");
            }
                break;
            case GKInviteeResponseDeclined:
            {
                NSLog(@"GKInviteeResponseDeclined");
            }
                break;
            case GKInviteeResponseFailed:
            {
                NSLog(@"GKInviteeResponseFailed");
            }
                break;
            case GKInviteeResponseIncompatible:
            {
                NSLog(@"GKInviteeResponseIncompatible");
            }
                break;
            case GKInviteeResponseUnableToConnect:
            {
                
                NSLog(@"GKInviteeResponseUnableToConnect");
            }
                break;
            case GKInviteeResponseNoAnswer:
            {
                NSLog(@"GKInviteeResponseNoAnswer");
                
            }
                break;
                
            default:
                break;
        }
        
    };
    
    
    GKMatchmakerViewController *vcMMaker = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    vcMMaker.matchmakerDelegate = sender;
    
    [sender presentViewController:vcMMaker animated:YES completion:nil];
    
    
}

@end
