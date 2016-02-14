//
//  PublishPhotoViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 27.01.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "PublishPhotoViewController.h"
#import "AppDelegate.h"
#import "NavigationViewController.h"

@interface PublishPhotoViewController ()

@end

@implementation PublishPhotoViewController
{
    ApiManager *api;
    NSMutableArray<StoryModel> *stories;
    StoryModel *selectedStory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view sendSubviewToBack:_uivBackground];
    
    api = [AppDelegate getInstance].api;
    
    _uivImage.image = _Image;
    // Do any additional setup after loading the view.
    [_pvStoryPicker setDataSource:self];
    [_pvStoryPicker setDelegate:self];
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"ru-RU"]];
    [df setDateFormat:@"LLLL"];
    NSString *month = [df stringFromDate:[NSDate new]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger year = [components year];
    
    _lblYear.text = [@(year) stringValue];
    _lblMonth.text = [NSString stringWithFormat:@"%@ ", month];
    _lblDay.text = [NSString stringWithFormat:@"%d, ",[@(day) intValue]];
    
    [self updateStories:api.Stories];
}

-(void)updateStories:(NSArray*)newStories{
    stories = [NSMutableArray<StoryModel> new];
    for (StoryModel *story in newStories) {
        if(!story.progress.isOutdated){
            [stories addObject:story];
        }
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [api getStoryListWithResultBlock:^(NSArray<StoryModel> *result, NSString *error) {
        [self updateStories:result];
        [_pvStoryPicker reloadAllComponents];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return stories.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    StoryModel *story = stories[row];
    NSString *title = story.title;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedStory = stories[row];
}

- (IBAction)btnCancel_Clicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)btnPublish_Done{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NavigationViewController getInstance] navigateToStory:selectedStory];
    }];
}

- (IBAction)btnPublish_Clicked:(id)sender {
    
    if(stories.count > 0){
        selectedStory = stories[[@([_pvStoryPicker selectedRowInComponent:0]) intValue]];
    }
    
    NSData *image = UIImageJPEGRepresentation(_Image, 1.0f);
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [df stringFromDate:[NSDate new]];
    
    [[AppDelegate getInstance].api uploadImage:image ForStory:(selectedStory != NULL) ? selectedStory.id : 0 ForDate:date WithProgressBlock:^(float progress) {
        _pvUploadProgress.progress = progress;
        if(progress == 1.0f){
            [_btnPublish setTitle:@"обработка..." forState:UIControlStateDisabled];
        }
    } WithResultBlock:^(UploadImageResult *result) {
        if(result != NULL){
            if(stories.count < 1){
                [api getStoryListWithResultBlock:^(NSArray<StoryModel> *result, NSString *error) {
                    [self updateStories:result];
                    [_pvStoryPicker reloadAllComponents];
                    selectedStory = stories[[@([_pvStoryPicker selectedRowInComponent:0]) intValue]];
                    [self btnPublish_Done];
                }];
            }else{
              [self btnPublish_Done];
            }
        }else{
            
        }
    }];
    
    [_pvStoryPicker setUserInteractionEnabled:NO];
    [_pvStoryPicker setAlpha:.6];
    [_btnPublish setTitle:@"загрузка..." forState:UIControlStateDisabled];
    _btnPublish.enabled = false;
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
