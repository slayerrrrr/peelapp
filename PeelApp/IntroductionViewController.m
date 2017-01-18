#import "IntroductionViewController.h"
#import "Constant.h"

@implementation IntroductionViewController
@synthesize introScrollView;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
        NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
        
        NSArray *navTitleArray = [colorDic objectForKey:@"NavigationBarTitleColor"];
        float navTitleRed = [[navTitleArray objectAtIndex:0] floatValue]/255.0;
        float navTitleGreen = [[navTitleArray objectAtIndex:1] floatValue]/255.0;
        float navTitleBlue = [[navTitleArray objectAtIndex:2] floatValue]/255.0;
        float navTitleAlpha = [[navTitleArray objectAtIndex:3] floatValue];
        
        NSString *IntroductionViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"IntroductionViewController"];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
        label.text = IntroductionViewTabBarName;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:navTitleRed green:navTitleGreen blue:navTitleBlue alpha:navTitleAlpha];
        self.navigationItem.titleView = label;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        [view release];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        [rightBarButtonItem release];
        
        self.title = IntroductionViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"introductionView_tab_icon.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configScrollView];
}

-(void)dealloc{
    [introScrollView release];
    [super dealloc];
}

-(void)configScrollView{    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *infoDictionary = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"IntroductionViewConfig"];
    
    //配置图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"introduction_photo.png"];
    
    [self.introScrollView addSubview:imageView];
    [imageView release];
    
    //配置body
    NSString *body = [infoDictionary objectForKey:@"content"];
    CGSize bodyLabelSize = [self getProperSizeForLabel:body setTextFont:[UIFont fontWithName:@"Helvetica" size:15]];
    UITextView *bodyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 252, 320, bodyLabelSize.height)];
    bodyTextView.text = body;
    bodyTextView.font = [UIFont fontWithName:@"Helvetica" size:15];
    bodyTextView.backgroundColor = [UIColor clearColor];
    bodyTextView.editable = NO;
    
    NSArray *bodyColor = [infoDictionary objectForKey:@"bodyColor"];
    float bodyRed = [[bodyColor objectAtIndex:0] floatValue]/255;
    float bodyGreen = [[bodyColor objectAtIndex:1] floatValue]/255;
    float bodyBlue = [[bodyColor objectAtIndex:2] floatValue]/255;
    float bodyAlpha = [[bodyColor objectAtIndex:3] floatValue];
    bodyTextView.textColor = [UIColor colorWithRed:bodyRed green:bodyGreen blue:bodyBlue alpha:bodyAlpha];
    bodyTextView.scrollEnabled = NO;
    
    [self.introScrollView addSubview:bodyTextView];
    [bodyTextView release];
    
    //配置phone Button
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 212+bodyLabelSize.height, 145, 45)];
    phoneButton.backgroundColor = [UIColor clearColor];
    [phoneButton addTarget:self action:@selector(phoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"introductionView_phone_button.png"] forState:UIControlStateNormal];
    
    NSArray *phoneColor = [infoDictionary objectForKey:@"phoneColor"];
    float phoneRed = [[phoneColor objectAtIndex:0] floatValue]/255;
    float phoneGreen = [[phoneColor objectAtIndex:1] floatValue]/255;
    float phoneBlue = [[phoneColor objectAtIndex:2] floatValue]/255;
    float phoneAlpha = [[phoneColor objectAtIndex:3] floatValue];
    [phoneButton setTitleColor:[UIColor colorWithRed:phoneRed green:phoneGreen blue:phoneBlue alpha:phoneAlpha] forState:UIControlStateNormal];
    
    [self.introScrollView addSubview:phoneButton];
    [phoneButton release];
    
    //配置email Button
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(165, 212 + bodyLabelSize.height, 145, 45)];
    emailButton.backgroundColor = [UIColor clearColor];
    [emailButton addTarget:self action:@selector(emailButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [emailButton setBackgroundImage:[UIImage imageNamed:@"introductionView_email_button.png"] forState:UIControlStateNormal];
    
    NSArray *emailColor = [infoDictionary objectForKey:@"phoneColor"];
    float emailRed = [[emailColor objectAtIndex:0] floatValue]/255;
    float emailGreen = [[emailColor objectAtIndex:1] floatValue]/255;
    float emailBlue = [[emailColor objectAtIndex:2] floatValue]/255;
    float emailAlpha = [[emailColor objectAtIndex:3] floatValue];
    [emailButton setTitleColor:[UIColor colorWithRed:emailRed green:emailGreen blue:emailBlue alpha:emailAlpha] forState:UIControlStateNormal];
    
    [self.introScrollView addSubview:emailButton];
    [emailButton release];
    
    [self.introScrollView setContentSize:CGSizeMake(320, 270+bodyLabelSize.height)];
}

-(void)phoneButtonPressed{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *infoDictionary = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"IntroductionViewConfig"];
    
    NSString *title = [NSString stringWithFormat:@"拨打电话: %@", [infoDictionary objectForKey:@"phone"]];                   
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
        NSDictionary *infoDictionary = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"IntroductionViewConfig"];
        
        NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[infoDictionary objectForKey:@"phone"]]];   
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:)]) {
            [[UIApplication sharedApplication] openURL:phoneNumberURL]; 
        }
    }
}

-(void)emailButtonPressed{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *infoDictionary = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"IntroductionViewConfig"];
    
    if( [MFMailComposeViewController canSendMail] ){
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        
        NSArray *array = [NSArray arrayWithObject:[infoDictionary objectForKey:@"email"]];
        [controller setToRecipients:array];
        [self presentModalViewController:controller animated:YES];
        [controller release];
    }
    else {
        UIAlertView * mailAlert = [[UIAlertView alloc] initWithTitle:@"请确认邮箱配置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        mailAlert.frame = CGRectMake(50, 150, 100, 90);
        [mailAlert show];
        [mailAlert release];
    }	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

//根据文字内容,判断label大小
- (CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont {
	///设置最大限度
	CGSize maximumLabelSize = CGSizeMake(200,10000);
	
	//预判label大小
	CGSize expectedLabelSize = [text	
								sizeWithFont:textFont
								constrainedToSize:maximumLabelSize 
								lineBreakMode:UILineBreakModeTailTruncation]; 
    
    expectedLabelSize.height = expectedLabelSize.height + 10;
	
	return expectedLabelSize;
}

@end

