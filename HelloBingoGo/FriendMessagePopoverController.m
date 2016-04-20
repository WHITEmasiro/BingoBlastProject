//
//  FriendMessagePopoverController.m
//  HelloBingoGo
//
//  Created by 陳韋中 on 2016/4/11.
//  Copyright © 2016年 hdes93404lg. All rights reserved.
//

#import "FriendMessagePopoverController.h"
#import "FriendMessageTableViewCell.h"

@interface FriendMessagePopoverController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *friendMessageTableView;

@end

@implementation FriendMessagePopoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.preferredContentSize = CGSizeMake(400,400);
    
    self.friendMessageTableView.delegate = self;
    self.friendMessageTableView.dataSource = self;
}

#pragma mark - TableView!
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendMessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    return messageCell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
