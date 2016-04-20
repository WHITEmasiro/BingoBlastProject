//
//  PlayMainMenu.m
//  HelloBingo
//
//  Created by WHITEer on 2016/04/17.
//  Copyright © 2016年 WHITEer. All rights reserved.
//

#import "PlayMainMenuViewController.h"
#import "SinglePlayerGameViewController.h"

@interface PlayMainMenuViewController ()

@end

@implementation PlayMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)singlePlayerBtnPressed:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"AI強度" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* easy = [UIAlertAction actionWithTitle:@"簡單" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startSinglePlayerGameWithAIStrength:AIStrengthEasy];
    }];
    UIAlertAction* normal = [UIAlertAction actionWithTitle:@"普通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startSinglePlayerGameWithAIStrength:AIStrengthNormal];
    }];
    UIAlertAction* hard = [UIAlertAction actionWithTitle:@"困難" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startSinglePlayerGameWithAIStrength:AIStrengthHard];
    }];
    UIAlertAction* dynamic = [UIAlertAction actionWithTitle:@"鏡中的你" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startSinglePlayerGameWithAIStrength:AIStrengthDynamic];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:easy];
    [alertController addAction:normal];
    [alertController addAction:hard];
    [alertController addAction:dynamic];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:true completion:nil];
    
    
}

- (void) startSinglePlayerGameWithAIStrength:(AIStrengthConfig)aiStr{
    
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SinglePlayerGameViewController* singlePlayerGameViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SinglePlayerGameViewController"];
    singlePlayerGameViewController.aiStrength  = aiStr;
    [self presentViewController:singlePlayerGameViewController animated:true completion:nil];
    
}

#pragma screen access

-(bool) shouldAutorotate{
    return false;
}

-(BOOL)prefersStatusBarHidden{
    return true;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
