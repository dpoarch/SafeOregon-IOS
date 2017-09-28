//
//  TipListViewController.m
//  Sprigeo
//
//  Created by eTech Developer on 09/02/16.
//
//

#import "TipListViewController.h"
#import "TipDetailViewController.h"

@interface TipListViewController ()
{
    NSMutableArray *arrTips;
}
@end

@implementation TipListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view endEditing:YES];
    
    self.title = [appDelegate getValueForLabelWithId:@"TITLE_MY_TIP"];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    arrTips = [[NSMutableArray alloc] init];
    
    NSDate * date=[[NSDate alloc] init];
    NSDateFormatter * formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringFromDate = [formate stringFromDate:date];
    
    
    NSDictionary *tip1 = @{ @"TipId" : @"12345",
                           @"Date" : stringFromDate,
                           @"Detaile" : @"this is for teting of this tip Detaile and IT was nice"
                           };
    [arrTips addObject:tip1];
    NSDictionary *tip2 = @{ @"TipId" : @"25468",
                            @"Date" : stringFromDate,
                            @"Detaile" : @"this is for teting of this tip Detaile and IT was nice"
                            };
    [arrTips addObject:tip2];
    NSDictionary *tip3 = @{ @"TipId" : @"365468",
                            @"Date" : stringFromDate,
                            @"Detaile" : @"this is for teting of this tip Detaile and IT was nice"
                            };
    [arrTips addObject:tip3];
    NSDictionary *tip4 = @{ @"TipId" : @"48946231",
                            @"Date" : stringFromDate,
                            @"Detaile" : @"this is for teting of this tip Detaile and IT was nice"
                            };
    [arrTips addObject:tip4];
    NSDictionary *tip5 = @{ @"TipId" : @"532489474",
                            @"Date" : stringFromDate,
                            @"Detaile" : @"this is for teting of this tip Detaile and IT was nice"
                            };
    [arrTips addObject:tip5];
    
    tblTipList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = [UIColor colorWithRed:0.32 green:0.75 blue:0.84 alpha:1.0];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    [backButton release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [arrTips count];}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        
        cell.backgroundColor = [UIColor clearColor];
        
        UIButton *btnDelete = [[UIButton alloc] initWithFrame:
                               CGRectMake(appDelegate.window.frame.size.width - 90, 10, 70, 25.0)];
        
        [btnDelete setBackgroundColor:[UIColor grayColor]];
        [btnDelete setTitle:@"View" forState:UIControlStateNormal];
        [btnDelete setContentMode:UIViewContentModeScaleAspectFit];
        [btnDelete addTarget:self action:@selector(btnDeletePress:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnDelete setFont:[UIFont systemFontOfSize:15.0]];
        btnDelete.layer.cornerRadius = 5.0;
        
        [cell.contentView addSubview:btnDelete];
    }
    
    @try {
        
        NSDictionary *dataForRowAtIndexPath = [arrTips objectAtIndex:(indexPath.row )];
        
        cell.textLabel.text = [dataForRowAtIndexPath valueForKey:@"TipId"];
        cell.detailTextLabel.text = [dataForRowAtIndexPath valueForKey:@"Date"];
    }
    @catch (NSException *exception) {
        eTechLog(@"cellForRowAtIndexPath %@",exception);
    }
    @finally {
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark – UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell=(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    
//    NSDictionary *dataForRowAtIndexPath = [arrTips objectAtIndex:(indexPath.row)];
//        
//    ManageViewController *viewController = [[ManageViewController alloc] initWithNibName:@"ManageViewController" bundle:nil];
//    viewController.dicMemberDetaile = dataForRowAtIndexPath;
//    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tblTipList respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblTipList setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblTipList respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblTipList setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)btnDeletePress:(UIButton *)sender {
    
//    int i = (long)sender.tag;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblTipList];
    NSIndexPath *indexPath = [tblTipList indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary *dataForRowAtIndexPath = [arrTips objectAtIndex:indexPath.row];
    
    TipDetailViewController *viewController = [[TipDetailViewController alloc] initWithNibName:@"TipDetailViewController" bundle:nil];
    viewController.tipDetail = dataForRowAtIndexPath;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [tblTipList release];
    [super dealloc];
}
@end
