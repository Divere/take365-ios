//
//  StoryViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "StoryViewController.h"
#import "AppDelegate.h"
#import "PhotoCollectionViewCell.h"
#import "CalendarCollectionViewCell.h"
#import "MonthCollectionReusableView.h"
#import "StoryDay.h"
#import "NSDate+Extensions.h"
#import "NSString+Extensions.h"
#import "NSIndexPath+Extensions.h"

@import KCFloatingActionButton;

@interface StoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KCFloatingActionButtonDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

@end

@implementation StoryViewController
{
    StoryResult *storyInfo;
    UICollectionViewCell *selectedCell;
    NSIndexPath *selectedIndexPath;
    float stockHeight;
    float stockWidth;
    
    NSMutableDictionary *imageCache;
    NSMutableDictionary *sections;
    NSArray *sortedSectionsTitles;
    
    NSMutableDictionary *visibleImages;
    NSMutableDictionary *imagesByDays;
    NSMutableArray *days;
    NSMutableDictionary *daysByDates;
    
    BOOL isScrollingFast;
    BOOL bigViewEnabled;
    BOOL isContributingStory;
    
    CGPoint lastOffset;
    NSTimeInterval lastOffsetCapture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageCache = [NSMutableDictionary new];
    visibleImages = [NSMutableDictionary new];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)_uivPhotos.collectionViewLayout;
    layout.sectionHeadersPinToVisibleBounds = true;
    [_uivPhotos setDataSource:self];
    [_uivPhotos setDelegate:self];
    
    self.title = _Story.title;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"вид" style:UIBarButtonItemStyleDone target:self action:@selector(changeView)];
    
    KCFloatingActionButton *fab = [[KCFloatingActionButton alloc] init];
    fab.buttonImage = [UIImage imageNamed:@"Camera"];
    fab.buttonColor = [UIColor redColor];
    fab.fabDelegate = self;
    [self.view addSubview:fab];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = TRUE;
    [self.uivPhotos addGestureRecognizer:lpgr];
    [self refreshStoryData];
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self refreshStoryData];
    if(self.TakeApi.imageForUpload != NULL) {
        [self uploadImage:self.TakeApi.imageForUpload forDate:[[NSDate new] toyyyyMMddString] selectedIndexPathCopy:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.TakeApi.imageForUpload = NULL;
    }
}

-(void)emptyKCFABSelected:(KCFloatingActionButton *)fab {
    NSDate *today = [[NSDate new] setZeroTime];
    NSString *todayString = [today toyyyyMMddString];
    if([imagesByDays objectForKey:todayString] != NULL) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Фотография уже существует" message:@"Данное действие заменит уже существующую фотографию" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Продолжить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:NULL];
            [self performSegueWithIdentifier:@"SEGUE_CAPTURE_PHOTO" sender:self];
        }]];
         
         [alert addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:NULL];
        }]];
        
        [self presentViewController:alert animated:YES completion:NULL];
        return;
    }
    
    [self performSegueWithIdentifier:@"SEGUE_CAPTURE_PHOTO" sender:self];
}


-(void)changeView{
    bigViewEnabled = !bigViewEnabled;
    [imageCache removeAllObjects];
    [_uivPhotos reloadData];
}

- (void)refreshStoryData
{
    sections = [NSMutableDictionary new];
    imagesByDays = [NSMutableDictionary new];
    days = [NSMutableArray new];
    daysByDates = [NSMutableDictionary new];
    [self.TakeApi getStoryWithId:_Story.id WithResultBlock:^(StoryResult *result, NSString *error) {
        if(error != NULL){
            return;
        }
        
        storyInfo = result;
        
        for (AuthorModel *author in storyInfo.authors) {
            if(author.id == self.TakeApi.CurrentUser.id){
                isContributingStory = true;
                break;
            }
        }
        
        for (StoryImageImagesModel *image in result.images) {
            [imagesByDays setObject:image forKey:image.date];
        }
        
        NSDate *dateStart = [[storyInfo.progress.dateStart dateFromyyyyMMddString] setZeroTime];
        NSDate *dateEnd = [[storyInfo.progress.dateEnd dateFromyyyyMMddString] setZeroTime];
        NSDate *today = [NSDate GetLocalDate];
        
        StoryDay *firstDay = [StoryDay new];
        firstDay.day = [dateStart toyyyyMMddString];
        firstDay.image = [imagesByDays objectForKey:firstDay.day];
        
        if(firstDay.image != NULL || isContributingStory) {
            [days insertObject:firstDay atIndex:0];
            [daysByDates setObject:firstDay forKey:[dateStart toyyyyMMddString]];
        }
        
        NSDate *currentDate = dateStart;
        
        for (int i=0; i<storyInfo.progress.passedDays + 2; i++) {
            currentDate = [currentDate dateByAddingTimeInterval:86400];
            if([currentDate compare:dateEnd] == NSOrderedDescending || [currentDate compare:today] == NSOrderedDescending){
                NSLog(@"Breaking on %@", currentDate);
                break;
            }
            
            StoryDay *storyDay = [StoryDay new];
            storyDay.day = [currentDate toyyyyMMddString];
            storyDay.image = [imagesByDays objectForKey:storyDay.day];
            
            if(storyDay.image == NULL && !isContributingStory){
                continue;
            }
            
            [days insertObject:storyDay atIndex:0];
            [daysByDates setObject:storyDay forKey:[currentDate toyyyyMMddString]];
        }
        
        for (StoryDay *storyDay in days) {
            NSArray *sectionTitleComponents = [storyDay.day componentsSeparatedByString:@"-"];
            NSString *sectionTitle = [NSString stringWithFormat:@"%@-%@", sectionTitleComponents[0], sectionTitleComponents[1]];
            
            NSMutableArray *sectionContent = [sections objectForKey:sectionTitle];
            
            if(sectionContent == NULL){
                sectionContent = [NSMutableArray new];
                [sections setObject:sectionContent forKey:sectionTitle];
            }
            
            [sectionContent addObject:storyDay];
        }
        
        sortedSectionsTitles = [[sections allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *key1 = obj1;
            NSString *key2 = obj2;
            
            NSDate *date1 = [key1 dateFromyyyyMMString];
            NSDate *date2 = [key2 dateFromyyyyMMString];
            
            if([date1 compare:date2] == NSOrderedDescending){
                return false;
            }else{
                return true;
            }
        }];
        
        [_uivPhotos reloadData];
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return sections.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    MonthCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SUPPLEMENTARY_MONTH" forIndexPath:indexPath];
    
    NSString *sectionTitle = sortedSectionsTitles[indexPath.section];
    
    NSDate *date = [sectionTitle dateFromyyyyMMString];
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [df setDateFormat:@"LLLL"];
    NSString *month = [df stringFromDate:date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger year = [components year];
    
    view.lblMonth.text = month;
    view.lblYear.text = [@(year) stringValue];
    
    return view;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSString *key = sortedSectionsTitles[section];
    NSMutableArray *sectionImages = [sections objectForKey:key];
    
    return sectionImages.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(bigViewEnabled){
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width);
    }else{
        return CGSizeMake(95, 95);
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [visibleImages setObject:indexPath forKey:[indexPath toKeyString]];
    
    NSString *key = sortedSectionsTitles[indexPath.section];
    NSMutableArray *sectionImages = [sections objectForKey:key];
    StoryDay *storyDay = sectionImages[indexPath.row];
    
    if(storyDay.image == NULL){
        CalendarCollectionViewCell *calendarCell = [_uivPhotos dequeueReusableCellWithReuseIdentifier:@"CalendarCollectionViewCell" forIndexPath:indexPath];
        NSString *dayText = [storyDay.day componentsSeparatedByString:@"-"][2];
        calendarCell.StoryDay = storyDay;
        calendarCell.lblDay.text = dayText;
        calendarCell.lblDay.hidden = false;
        [calendarCell.pbUploadProgress setProgress:storyDay.uploadProgress];
        return calendarCell;
    }
    
    PhotoCollectionViewCell *cell = NULL;
    
    if(bigViewEnabled){
        cell = [_uivPhotos dequeueReusableCellWithReuseIdentifier:@"BigPhotoCollectionViewCell" forIndexPath:indexPath];
    }else{
        cell = [_uivPhotos dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    }
    
    [cell.pbUploadProgress setProgress:storyDay.uploadProgress];
    
    UIImage *image = [imageCache objectForKey:[indexPath toKeyString]];
    
    if(!isScrollingFast && image == nil){
        [cell.ivPhoto setHidden:true];
        [cell.aiLoading setHidden:false];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            NSIndexPath *cellPath = [indexPath copy];
            
            UIImage *downloadedImage = NULL;
            
            if(!isScrollingFast){
                if(!bigViewEnabled){
                    downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:storyDay.image.thumb.url]]];
                }else{
                    downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:storyDay.image.image.url]]];
                }
                
                if(downloadedImage != NULL){
                    [imageCache setObject:downloadedImage forKey:[cellPath toKeyString]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_uivPhotos reloadItemsAtIndexPaths:@[cellPath]];
                    });
                }
            }
        });
    }
    
    if(isScrollingFast && image == NULL){
        cell.StoryDay = NULL;
        [cell.ivPhoto setImage:NULL];
        cell.lblDay.hidden = true;
        cell.ivPhoto.hidden = true;
        cell.aiLoading.hidden = false;
    }else{
        cell.StoryDay = storyDay;
        [cell.ivPhoto setImage:image];
        cell.lblDay.text = [storyDay.image.date componentsSeparatedByString:@"-"][2];
        [cell.ivPhoto setHidden:false];
        [cell.aiLoading setHidden:true];
        cell.lblDay.hidden = false;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [visibleImages removeObjectForKey:[indexPath toKeyString]];
}

- (void)showImagePicker {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = FALSE;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndexPath = indexPath;
    selectedCell = [_uivPhotos cellForItemAtIndexPath:indexPath];
    
    if([selectedCell isKindOfClass:[PhotoCollectionViewCell class]]){
        PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)selectedCell;
        if(cell.StoryDay){
            return [self performSegueWithIdentifier:@"SEGUE_SHOW_IMAGE" sender:self];
        }
    }
    
    if([selectedCell isKindOfClass:[CalendarCollectionViewCell class]]){
        CalendarCollectionViewCell *cell = (CalendarCollectionViewCell*)selectedCell;
        [cell changeSelectedColor:YES];
        [self showImagePicker];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.uivPhotos];
    
    NSIndexPath *indexPath = [self.uivPhotos indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        selectedIndexPath = indexPath;
        selectedCell = [self.uivPhotos cellForItemAtIndexPath:indexPath];
        StoryItemCollectionViewCell *cell = (StoryItemCollectionViewCell*)selectedCell;
        [cell changeSelectedColor:YES];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Выберите действие" message:NULL preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Заменить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showImagePicker];
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [cell changeSelectedColor:NO];
            [actionSheet dismissViewControllerAnimated:YES completion:NULL];
        }]];
        [self presentViewController:actionSheet animated:YES completion:NULL];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint currentOffset = scrollView.contentOffset;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval timeDiff = currentTime - lastOffsetCapture;
    if(timeDiff > 0.1) {
        CGFloat distance = currentOffset.y - lastOffset.y;
        //The multiply by 10, / 1000 isn't really necessary.......
        CGFloat scrollSpeedNotAbs = (distance * 10) / 1000; //in pixels per millisecond
        
        CGFloat scrollSpeed = fabsf(scrollSpeedNotAbs);
        if (scrollSpeed > 2) {
            isScrollingFast = TRUE;
        } else {
            isScrollingFast = FALSE;
        }
        
        lastOffset = currentOffset;
        lastOffsetCapture = currentTime;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    isScrollingFast = false;
    [_uivPhotos reloadItemsAtIndexPaths:[visibleImages allValues]];
}

- (void)uploadImage:(UIImage *)pickedImage forDate:(NSString *)date selectedIndexPathCopy:(NSIndexPath *)selectedIndexPathCopy {
    
    NSData *image = UIImageJPEGRepresentation(pickedImage, 1.0f);
    [self.TakeApi uploadImage:image ForStory:storyInfo.id ForDate:date WithProgressBlock:^(float progress) {
        StoryItemCollectionViewCell *uploadingCell = (StoryItemCollectionViewCell*)[_uivPhotos cellForItemAtIndexPath:selectedIndexPathCopy];
        if(uploadingCell){
            uploadingCell.StoryDay.uploadProgress = progress;
            [uploadingCell.pbUploadProgress setProgress:progress];
        }
    } WithResultBlock:^(UploadImageResult *result) {
        if(result != NULL){
            StoryItemCollectionViewCell *uploadingCell = (StoryItemCollectionViewCell*)[_uivPhotos cellForItemAtIndexPath:selectedIndexPathCopy];
            if(uploadingCell){
                uploadingCell.StoryDay.uploadProgress = 0;
                [uploadingCell.pbUploadProgress setProgress:0];
            }
            [imageCache removeObjectForKey:[selectedIndexPathCopy toKeyString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshStoryData];
            });
        }else{
            
        }
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    CalendarCollectionViewCell *cell = (CalendarCollectionViewCell*)selectedCell;
    [cell changeSelectedColor:NO];
    
    NSIndexPath *selectedIndexPathCopy = [selectedIndexPath copy];
    
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self uploadImage:pickedImage forDate:cell.StoryDay.day selectedIndexPathCopy:selectedIndexPathCopy];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    CalendarCollectionViewCell *cell = (CalendarCollectionViewCell*)selectedCell;
    [cell changeSelectedColor:NO];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SEGUE_SHOW_IMAGE"]){
        PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)selectedCell;
        [segue.destinationViewController setValue:cell.StoryDay.image forKey:@"Image"];
    }
}

@end
