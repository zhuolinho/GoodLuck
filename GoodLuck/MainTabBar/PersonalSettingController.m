//
//  PersonalSettingController.m
//  GoodLuck
//
//  Created by shenyang on 15/9/4.
//
//

#import "PersonalSettingController.h"
#import "API.h"

@interface PersonalSettingController () <APIProtocol>
{
    API *myAPI;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *cellMyMessage;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellLiveHistory;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellMessageSetting;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellVoice;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellVibrate;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellClear;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellAbout;

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UISwitch *switchVibrate;
@property (strong, nonatomic) IBOutlet UISwitch *switchVoice;
@end

@implementation PersonalSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellMyMessage.textLabel.text = @"消息中心";
    _cellLiveHistory.textLabel.text = @"历史直播";
    
    _cellMessageSetting.textLabel.text = @"消息设置";
    _cellVoice.textLabel.text = @"声音";
    _cellVibrate.textLabel.text = @"震动";
    _cellClear.textLabel.text = @"清除缓存";
    _cellAbout.textLabel.text = @"关于mEye";
    
    [_avatarImage setImage:[UIImage imageNamed:@"avatar"]];
    
    [_switchVoice addTarget:self action:@selector(switchVoiceChange:) forControlEvents:UIControlEventValueChanged];
    [_switchVibrate addTarget:self action:@selector(switchVibrateChange:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
//    [myAPI login];
}

- (void)switchVoiceChange:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"switch voice on");
    }else {
        NSLog(@"switch voice off");
    }
}

- (void)switchVibrateChange:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"switch vibrate on");
    }else {
        NSLog(@"switch vibrate off");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)selectRightAction:(id)sender {
    NSLog(@"select right action");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveAPIErrorOf:(API *)api data:(int)errorNo {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接情况" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    NSString *status_code = data[@"status_code"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([status_code  isEqual: @"0"]) {
            NSDictionary *res = data[@"data"];
            NSLog(@"%@",res);
            _userName.text = res[@"userName"];
        }
    });
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
