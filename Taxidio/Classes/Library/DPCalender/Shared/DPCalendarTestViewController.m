//
//  DPCalendarTestViewController.m
//  DPCalendar
//
//  Created by Ethan Fang on 19/12/13.
//  Copyright (c) 2013 Ethan Fang. All rights reserved.
//

#import "DPCalendarTestViewController.h"
#import "DPCalendarMonthlySingleMonthViewLayout.h"

#import "DPCalendarMonthlyView.h"
#import "DPCalendarEvent.h"
#import "DPCalendarIconEvent.h"
#import "NSDate+DP.h"
#import "DPCalendarTestOptionsViewController.h"
#import "DPCalendarTestCreateEventViewController.h"

@interface DPCalendarTestViewController ()<DPCalendarMonthlyViewDelegate, DPCalendarTestCreateEventViewControllerDelegate>

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *todayButton;
@property (nonatomic, strong) UIButton *createEventButton;
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSMutableArray *iconEvents;

@property (nonatomic, strong) DPCalendarMonthlyView *monthlyView;

@end

@implementation DPCalendarTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self generateData];
        [self commonInit];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self generateData];
        [self commonInit];
    }
    return self;
}

-(void) commonInit {
    [self generateMonthlyView];
    [self updateLabelWithMonth:self.monthlyView.seletedMonth];
}

- (void) generateMonthlyView {
    CGFloat width = [self.class currentSize].width;
    CGFloat height = [self.class currentSize].height;
    
    [self.previousButton removeFromSuperview];
    [self.nextButton removeFromSuperview];
    [self.monthLabel removeFromSuperview];
    [self.todayButton removeFromSuperview];
    [self.optionsButton removeFromSuperview];
    [self.createEventButton removeFromSuperview];
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake((width - 100) / 2, 20, 100, 20)];
    [self.monthLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousButton setBackgroundImage:[UIImage imageNamed:@"IconArrowPrev"] forState:UIControlStateNormal];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"IconArrowNext"] forState:UIControlStateNormal];
    self.todayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.optionsButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.createEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.createEventButton setBackgroundImage:[UIImage imageNamed:@"BtnAddSomething"] forState:UIControlStateNormal];
    self.previousButton.frame = CGRectMake(self.monthLabel.frame.origin.x - 18, 20, 18, 20);
    self.nextButton.frame = CGRectMake(CGRectGetMaxX(self.monthLabel.frame), 20, 18, 20);
    self.todayButton.frame = CGRectMake(width - 60, 20, 60, 21);
    self.backButton.frame = CGRectMake(40, 20, 50, 20);
//    self.optionsButton.frame = CGRectMake(width - 50 * 3, 20, 50, 20);
    self.createEventButton.frame = CGRectMake(10, 20, 20, 20);
    [self.todayButton setTitle:@"Today" forState:UIControlStateNormal];
    [self.optionsButton setTitle:@"Option" forState:UIControlStateNormal];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [self.previousButton addTarget:self action:@selector(previousButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(nextButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.todayButton addTarget:self action:@selector(todayButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(backButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsButton addTarget:self action:@selector(optionsButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.createEventButton addTarget:self action:@selector(createEventButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.monthLabel];
    [self.view addSubview:self.previousButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.todayButton];
    [self.view addSubview:self.backButton];
    //    [self.view addSubview:self.optionsButton];
    [self.view addSubview:self.createEventButton];
    [self.monthlyView removeFromSuperview];
    self.monthlyView = [[DPCalendarMonthlyView alloc] initWithFrame:CGRectMake(0, 50, width, height - 250) delegate:self];
    [self.view addSubview:self.monthlyView];
    
    [self.monthlyView setEvents:self.events complete:nil];
    [self.monthlyView setIconEvents:self.iconEvents complete:nil];
}

- (void) generateData
{
    self.events = @[].mutableCopy;
    self.iconEvents = @[].mutableCopy;
    
//    NSDate *date = [[NSDate date] dateByAddingYears:0 months:0 days:0];
//    NSDate *date1 = [[NSDate date] dateByAddingYears:0 months:0 days:3];
//    NSDate *date2 = [[NSDate date] dateByAddingYears:0 months:0 days:5];
//    UIImage *icon = [UIImage imageNamed:@"IconPubHol"];
//    UIImage *greyIcon = [UIImage imageNamed:@"IconDateGrey"];
    
//    NSArray *titles = @[@"France Trip", @"Switzerland Trip", @"West Europe Trip", @"India"];
    
//    for (int i = 0; i < 60; i++)
//    {
//        if (arc4random() % 2 > 0)
//        {
//            int index = arc4random() % 3;
//            DPCalendarEvent *event = [[DPCalendarEvent alloc] initWithTitle:[titles objectAtIndex:0] startTime:date endTime:[date dateByAddingYears:0 months:0 days:13] colorIndex:1];
//            [self.events addObject:event];
    
//    DPCalendarEvent *event1 = [[DPCalendarEvent alloc] initWithTitle:[titles objectAtIndex:1] startTime:date1 endTime:[date dateByAddingYears:0 months:0 days:3] colorIndex:2];
//    [self.events addObject:event1];
//
//
//    DPCalendarEvent *event2 = [[DPCalendarEvent alloc] initWithTitle:[titles objectAtIndex:2] startTime:date endTime:[date dateByAddingYears:0 months:0 days:11] colorIndex:3];
//    [self.events addObject:event2];
//
//    DPCalendarEvent *event13 = [[DPCalendarEvent alloc] initWithTitle:[titles objectAtIndex:3] startTime:date2 endTime:[date dateByAddingYears:0 months:0 days:17] colorIndex:4];
//    [self.events addObject:event13];


    
//        }
//
//        if (arc4random() % 2 > 0) {
//            DPCalendarIconEvent *iconEvent = [[DPCalendarIconEvent alloc] initWithStartTime:date endTime:[date dateByAddingYears:0 months:0 days:0] icon:icon];
//            [self.iconEvents addObject:iconEvent];
//
//            
//            iconEvent = [[DPCalendarIconEvent alloc] initWithTitle:[NSString stringWithFormat:@"HELLO"] startTime:date endTime:[date dateByAddingYears:0 months:0 days:0] icon:greyIcon bkgColorIndex:1];
//            [self.iconEvents addObject:iconEvent];
//        }
//        
//        date = [date dateByAddingYears:0 months:0 days:1];
//    }
}

- (void) backButtonSelected:(id)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) previousButtonSelected:(id)button {
    [self.monthlyView scrollToPreviousMonthWithComplete:nil];
}

-(void) nextButtonSelected:(id)button {
    [self.monthlyView scrollToNextMonthWithComplete:nil];
}

-(void) todayButtonSelected:(id)button {
    [self.monthlyView clickDate:[NSDate date]];
}

-(void) optionsButtonSelected:(id)button {
    DPCalendarTestOptionsViewController *optionController = [DPCalendarTestOptionsViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:optionController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"TEST" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 70, 40 );
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    navController.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void) createEventButtonSelected:(id)button {
    DPCalendarTestCreateEventViewController *createEventController = [DPCalendarTestCreateEventViewController new];
    createEventController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createEventController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"Done" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 70, 40 );
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    navController.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateLabelWithMonth:self.monthlyView.seletedMonth];
}

- (void) updateLabelWithMonth:(NSDate *)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:month];
    [self.monthLabel setText:stringFromDate];
}

#pragma DPCalendarMonthlyViewDelegate
-(void)didScrollToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate{
    [self updateLabelWithMonth:month];
}

-(void)didSkipToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    [self updateLabelWithMonth:month];
}

-(void)didTapEvent:(DPCalendarEvent *)event onDate:(NSDate *)date {
    NSLog(@"Touched event %@, date %@", event.title, date);
}

-(BOOL)shouldHighlightItemWithDate:(NSDate *)date {
    return YES;
}

-(BOOL)shouldSelectItemWithDate:(NSDate *)date {
    return YES;
}

-(void)didSelectItemWithDate:(NSDate *)date {
    NSLog(@"Select date %@ with \n events %@ \n and icon events %@", date, [self.monthlyView eventsForDay:date], [self.monthlyView iconEventsForDay:date]);
}



-(NSDictionary *) ipadMonthlyViewAttributes {
    return @{
             DPCalendarMonthlyViewAttributeCellRowHeight: @23,
             //             DPCalendarMonthlyViewAttributeEventDrawingStyle: [NSNumber numberWithInt:DPCalendarMonthlyViewEventDrawingStyleUnderline],
             DPCalendarMonthlyViewAttributeStartDayOfWeek: @0,
             DPCalendarMonthlyViewAttributeWeekdayFont: [UIFont systemFontOfSize:18],
             DPCalendarMonthlyViewAttributeDayFont: [UIFont systemFontOfSize:14],
             DPCalendarMonthlyViewAttributeEventFont: [UIFont systemFontOfSize:14],
             DPCalendarMonthlyViewAttributeMonthRows:@5,
             DPCalendarMonthlyViewAttributeIconEventBkgColors: @[[UIColor clearColor], [UIColor colorWithRed:239/255.f green:239/255.f blue:244/255.f alpha:1]]
             };
}

-(NSDictionary *) iphoneMonthlyViewAttributes {
    return @{
             DPCalendarMonthlyViewAttributeEventDrawingStyle: [NSNumber numberWithInt:DPCalendarMonthlyViewEventDrawingStyleUnderline],
             DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable: @YES,
             DPCalendarMonthlyViewAttributeMonthRows:@3
             };
    
}

-(NSDictionary *)monthlyViewAttributes {
        return [self iphoneMonthlyViewAttributes];
}

#pragma mark - Utilities

+(CGSize) currentSize
{
    return [self sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    return size;
}

#pragma mark - DPCalendarTestCreateEventViewControllerDelegate
-(void)eventCreated:(DPCalendarEvent *)event {
    [self.events addObject:event];
    [self.monthlyView setEvents:self.events complete:nil];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotate {
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self commonInit];
}

@end
