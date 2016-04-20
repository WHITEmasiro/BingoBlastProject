//
//  LeaderboardViewController.m
//  BingoBlast
//
//  Created by 陳韋中 on 2016/4/10.
//  Copyright © 2016年 hdes93404lg. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LeaderboardTableViewCell.h"

@interface LeaderboardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *leaderboardTableView;
@property (nonatomic,strong) NSMutableArray *leaderboardNameArray;
@property (nonatomic,strong) NSMutableArray *leaderboardNumberArray;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"排行榜";
    
    self.leaderboardTableView.delegate = self;
    self.leaderboardTableView.dataSource = self;
    
    self.leaderboardNameArray = [[NSMutableArray alloc] initWithObjects:@"阿中",@"Peter",@"政威",@"彥程",@"家豪",@"阿中",@"Peter",@"政威",@"彥程",@"家豪",nil];
    
    self.leaderboardNumberArray = [[NSMutableArray alloc] init];
    for (int i=1; i < 100; i++) {
        NSString *number = [NSString stringWithFormat:@"%i",i];
        [self.leaderboardNumberArray addObject:number];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView!

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leaderboardNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LeaderboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *Number = self.leaderboardNumberArray[indexPath.row];
    cell.leaderboardNumber.text = [Number description];
    
    NSString *friend = self.leaderboardNameArray[indexPath.row];
    cell.leaderboardName.text = [friend description];
    
    UIImage *image = [UIImage imageNamed:@"123456.jpg"];
    cell.leaderboardImageView.image = image;
    return cell;
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
