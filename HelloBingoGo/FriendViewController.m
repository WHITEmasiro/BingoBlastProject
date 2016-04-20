//
//  FriendViewController.m
//  HelloBingoGo
//
//  Created by 陳韋中 on 2016/4/11.
//  Copyright © 2016年 hdes93404lg. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendTableViewCell.h"
#import "Friends.h"

@interface FriendViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (nonatomic,strong) NSMutableArray *friendsArray;
@end

@implementation FriendViewController
{
    NSArray *searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"好友";
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    self.friendTableView.delegate = self;
    self.friendTableView.dataSource = self;
    
    self.friendsArray = [[NSMutableArray alloc] init];
    
    Friends *friend1 = [Friends new];
    friend1.name = @"阿中";
    friend1.image = @"123456.jpg";
    [self.friendsArray addObject:friend1];
    
    Friends *friend2 = [Friends new];
    friend2.name = @"Peter";
    friend2.image = @"2222.png";
    [self.friendsArray addObject:friend2];
    
    Friends *friend3 = [Friends new];
    friend3.name = @"政威";
    friend3.image = @"3333.jpg";
    [self.friendsArray addObject:friend3];
    
    Friends *friend4 = [Friends new];
    friend4.name = @"彥程";
    friend4.image = @"4444.png";
    [self.friendsArray addObject:friend4];
    
    Friends *friend5 = [Friends new];
    friend5.name = @"豪哥";
    friend5.image = @"5555.jpg";
    [self.friendsArray addObject:friend5];
    
    Friends *friend6 = [Friends new];
    friend6.name = @"Rabbit";
    friend6.image = @"6666.png";
    [self.friendsArray addObject:friend6];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return [self.friendsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    
    FriendTableViewCell *cell = (FriendTableViewCell *)[self.friendTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Friends *friend = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        friend = [searchResults objectAtIndex:indexPath.row];
    } else {
        friend = [self.friendsArray objectAtIndex:indexPath.row];
    }
    
    cell.firendName.text = friend.name;
    cell.friendImageView.image = [UIImage imageNamed:friend.image];
    
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [self.friendsArray filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        [self.friendsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    } else if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (IBAction)friendEditing:(id)sender {
    
    if ([self.friendTableView isEditing]) {
        [self.friendTableView setEditing:NO animated:YES];
    } else {
        [self.friendTableView setEditing:YES animated:YES];
    }
}

#pragma mark - SegueMyFriendMessage!

- (IBAction)myFriendMessage:(id)sender {
    
    [self performSegueWithIdentifier:@"showPopover" sender:nil];
}

-(void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showPopover"]) {
        UIViewController *vc = segue.destinationViewController;
        //vc.preferredContentSize = CGSizeMake(400,400);
        UIPopoverPresentationController *controller = vc.popoverPresentationController;
        controller.sourceRect = [sender bounds];
        controller.delegate = self;
    }
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

// 點擊周圍 popover不會消失
//-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
//    return NO;
//}


#pragma mark - SendMessageBtn!

- (IBAction)SendMessageBtn:(id)sender {
    
    UIAlertController * alertController =[UIAlertController alertControllerWithTitle:@"傳送訊息" message:@"請填入訊息內容" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"填寫訊息名稱"];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"填寫訊息內容"];
    }];
    
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"傳送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cancle];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)backGameHome:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
