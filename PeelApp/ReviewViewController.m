//
//  ReviewViewController.m
//  YangSheng
//
//  Created by Peelapp on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewTableViewCell.h"
#import "JSON.h"
#import "ComposeReviewViewController.h"

@implementation ReviewViewController
@synthesize queryIndex;
@synthesize dataArray;
@synthesize reviewTableView;
@synthesize indicator, loadingImageView;
@synthesize reviewURL;
@synthesize writeReviewButton;
@synthesize delegate;
@synthesize navBar;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
    
    NSArray *navTintArray = [colorDic objectForKey:@"NavigationBarTint"];
    float navRed = [[navTintArray objectAtIndex:0] floatValue]/255.0;
    float navGreen = [[navTintArray objectAtIndex:1] floatValue]/255.0;
    float navBlue = [[navTintArray objectAtIndex:2] floatValue]/255.0;
    
    self.navBar.tintColor = [UIColor colorWithRed:navRed green:navGreen blue:navBlue alpha:1];
    
    NSDictionary *cellDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"ReviewViewConfig"];
    
    NSArray *cellColorArray = [cellDic objectForKey:@"TableCellSeperator"];
    float cellRed = [[cellColorArray objectAtIndex:0] floatValue]/255.0;
    float cellGreen = [[cellColorArray objectAtIndex:1] floatValue]/255.0;
    float cellBlue = [[cellColorArray objectAtIndex:2] floatValue]/255.0;
    float cellAlpha = [[cellColorArray objectAtIndex:3] floatValue];
    
    self.reviewTableView.separatorColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:cellAlpha];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.dataArray = tempArray;
    [tempArray release];
    
    self.queryIndex = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    self.queryIndex = 0;
    [self.dataArray removeAllObjects];
    [self getMoreReviews];
}

-(void)dealloc{
    [reviewURL release];
    [dataArray release];
    [reviewTableView release];
    [indicator release];
    [loadingImageView release];
    [writeReviewButton release];
    [navBar release];
    
    [super dealloc];
}

-(void)getMoreReviews{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    self.loadingImageView.hidden = NO;
    
    NSString *url = [NSString stringWithFormat:@"%@?start=%d", reviewURL, self.queryIndex];
    NSLog(@"reviewURL: %@", url);
    
    GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:url delegate:self tag:0];
    [urlConnection release];
} 

-(IBAction)doneButtonPressed{
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate reviewViewControllerDoneButtonDidPressed:self];
}

-(IBAction)writeReviewButtonPressed{
    ComposeReviewViewController *viewController = [[ComposeReviewViewController alloc] init];
    viewController.postURL = reviewURL;
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark - Connection Delegate
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)urlConnection{
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    self.loadingImageView.hidden = YES;
    
    NSString *jsonString = [[NSString alloc] initWithData:urlConnection.receivedData encoding:NSUTF8StringEncoding];
    
    SBJSON *jsonParser = [[SBJSON alloc] init];
    NSError *error = nil;
    
    [self.dataArray addObjectsFromArray:[jsonParser objectWithString:jsonString error:&error]];
    NSLog(@"%@", dataArray);
    
    [jsonString release];
    [jsonParser release];
    
    self.reviewTableView.hidden = NO;
    [self.reviewTableView reloadData];
}

- (void)urlConnection:(GLURLConnection *)urlConnection didFailWithError:(NSError *)error{
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    self.loadingImageView.hidden = YES;
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新", nil];
    [alterView show];
    [alterView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.dataArray = tempArray;
        [tempArray release];
        
        self.queryIndex = 0;
        [self getMoreReviews];
    }
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataArray count] == self.queryIndex+20) {
        return [self.dataArray count]+1;
    }
    else{
        return [self.dataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.dataArray count]) {
        return 50;
    }
    else{
        CGSize contentLabelSize = [self getProperSizeForLabel:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"content"] setTextFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        return contentLabelSize.height + 30;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //show more cell
    if (indexPath.row < [self.dataArray count]) {
        static NSString *CellIdentifier = @"ReviewTableViewCell";
        ReviewTableViewCell *cell = (ReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) { 
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
            for (id oneObject in nib) if ([oneObject isKindOfClass:[ReviewTableViewCell class]]){
                cell = (ReviewTableViewCell *)oneObject;
                
                NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
                NSDictionary *cellDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"ReviewViewConfig"];
                
                NSArray *contentColorArray = [cellDic objectForKey:@"TableCellTitleColor"];
                float cellRed = [[contentColorArray objectAtIndex:0] floatValue]/255.0;
                float cellGreen = [[contentColorArray objectAtIndex:1] floatValue]/255.0;
                float cellBlue = [[contentColorArray objectAtIndex:2] floatValue]/255.0;
                float cellAlpha = [[contentColorArray objectAtIndex:3] floatValue];
                
                cell.contentLabel.textColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:cellAlpha];
                
                NSArray *userColorArray = [cellDic objectForKey:@"TableCellUserAndDateColor"];
                float userRed = [[userColorArray objectAtIndex:0] floatValue]/255.0;
                float userGreen = [[userColorArray objectAtIndex:1] floatValue]/255.0;
                float userBlue = [[userColorArray objectAtIndex:2] floatValue]/255.0;
                float userAlpha = [[userColorArray objectAtIndex:3] floatValue];
                
                cell.dateLabel.textColor = [UIColor colorWithRed:userRed green:userGreen blue:userBlue alpha:userAlpha];
                cell.accountLabel.textColor = [UIColor colorWithRed:userRed green:userGreen blue:userBlue alpha:userAlpha];
            }   
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGSize contentLabelSize = [self getProperSizeForLabel:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"content"] setTextFont:[UIFont fontWithName:@"Helvetica" size:14]];
        cell.contentLabel.frame = CGRectMake(10, 25, 300, contentLabelSize.height);
        cell.contentLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        
        cell.dateLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"];
        cell.accountLabel.text = [NSString stringWithFormat:@"用户: %@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (indexPath.section == 0) {
            //初始化cell
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                               reuseIdentifier: cellIdentifier] autorelease];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([[cell.contentView subviews] count] == 0) {
            self.queryIndex = self.queryIndex + 20;
            
            UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 279, 43)];
            [moreButton addTarget:self action:@selector(getMoreReviews) forControlEvents:UIControlEventTouchUpInside];
            [moreButton setImage:[UIImage imageNamed:@"review_load_more_button.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:moreButton];
            [moreButton release];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击之后取消反显效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//根据文字内容,判断label大小
- (CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont {
	//设置最大限度
	CGSize maximumLabelSize = CGSizeMake(300, 1000);
	
	//预判label大小
	CGSize expectedLabelSize = [text	
								sizeWithFont:textFont
								constrainedToSize:maximumLabelSize 
								lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedLabelSize;
}

@end
