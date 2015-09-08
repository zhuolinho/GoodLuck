//
//  MyWatchController.m
//  GoodLuck
//
//  Created by shenyang on 15/9/4.
//
//

#import "MonitorController.h"
#import "CallingViewController.h"

@interface MonitorController ()
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *selfTableView;

@property (strong, nonatomic) UIView *viewChoose;

@end

@implementation MonitorController
{
    NSArray *recipes;
    BOOL flagViewChooseHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    recipes = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [_selfTableView addSubview:_refreshControl];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scanRightUp"] style:UIBarButtonItemStylePlain  target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _selfTableView.separatorStyle = UITableViewCellSelectionStyleDefault;
    [_selfTableView setSeparatorColor:[UIColor blackColor]];
    
    _viewChoose = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-92, 64, 92, 86)];
    [_viewChoose setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_viewChoose];
}

- (void)viewWillAppear:(BOOL)animated {
    [_viewChoose setHidden:YES];
    flagViewChooseHidden = YES;
}

- (void)selectRightAction:(id)sender {
    NSLog(@"press navigation right action");
    flagViewChooseHidden = !flagViewChooseHidden;
    [_viewChoose setHidden:flagViewChooseHidden];
}

-(void) refreshView:(UIRefreshControl *)refresh {
    NSLog(@"End Refreshing\n");
    [refresh endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  280;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"monitorCell" forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [recipes objectAtIndex:indexPath.row];
    UIButton *button = (UIButton *)[cell viewWithTag:321];
    [button setTitle:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 9000] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)buttonClick:(UIButton *)button {
    UIStoryboard *callingStoryboard = [UIStoryboard storyboardWithName:@"Calling" bundle:nil];
    CallingViewController *vc = (CallingViewController *)[callingStoryboard instantiateInitialViewController];
    vc.toSip = [button.titleLabel.text UTF8String];
    [self presentViewController:vc animated:true completion:nil];
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
