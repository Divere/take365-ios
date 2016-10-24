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

@interface StoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
    
    CGPoint lastOffset;
    NSTimeInterval lastOffsetCapture;
    BOOL isScrollingFast;
    
    NSMutableDictionary *visibleImages;
    
    BOOL bigViewEnabled;
    
    NSMutableDictionary *imagesByDays;
    NSMutableArray *days;
    
    BOOL isContributingStory;
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
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshStoryData];
}

-(void)changeView{
    bigViewEnabled = !bigViewEnabled;
    [imageCache removeAllObjects];
    [_uivPhotos reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshStoryData
{
    sections = [NSMutableDictionary new];
    imagesByDays = [NSMutableDictionary new];
    days = [NSMutableArray new];
    
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
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dateStart = [df dateFromString:storyInfo.progress.dateStart];
        NSDate *dateEnd = [df dateFromString:storyInfo.progress.dateEnd];
        
        for (int i=0; i<storyInfo.progress.passedDays + 1; i++) {
            NSDate *currentDate = [dateStart dateByAddingTimeInterval:i*24*60*60];
            if([currentDate compare:dateEnd] == NSOrderedDescending){
                break;
            }
            
            StoryDay *storyDay = [StoryDay new];
            storyDay.day = [df stringFromDate:currentDate];
            storyDay.image = [imagesByDays objectForKey:storyDay.day];
            
            if(storyDay.image == NULL && !isContributingStory){
                continue;
            }
            
            [days insertObject:storyDay atIndex:0];
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
            
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"yyyy-MM"];
            NSDate *date1 = [df dateFromString:key1];
            NSDate *date2 = [df dateFromString:key2];
            
            if([date1 compare:date2] == NSOrderedDescending){
                return false;
            }else{
                return true;
            }
        }];
        
        [_uivPhotos reloadData];
    }];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint currentOffset = scrollView.contentOffset;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval timeDiff = currentTime - lastOffsetCapture;
    if(timeDiff > 0.1) {
        CGFloat distance = currentOffset.y - lastOffset.y;
        //The multiply by 10, / 1000 isn't really necessary.......
        CGFloat scrollSpeedNotAbs = (distance * 10) / 1000; //in pixels per millisecond
        
        CGFloat scrollSpeed = fabsf(scrollSpeedNotAbs);
        if (scrollSpeed > 2) {
            isScrollingFast = YES;
        } else {
            isScrollingFast = NO;
        }
        
        lastOffset = currentOffset;
        lastOffsetCapture = currentTime;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return sections.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    MonthCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SUPPLEMENTARY_MONTH" forIndexPath:indexPath];
    
    NSString *sectionTitle = sortedSectionsTitles[indexPath.section];
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [df setDateFormat:@"yyyy-MM"];
    NSDate *date = [df dateFromString:sectionTitle];
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
    
    [visibleImages setObject:indexPath forKey:[NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row]];
    
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
    
    UIImage *image = [imageCache objectForKey:[NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row]];
    
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
                    downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:storyDay.image.thumbLarge.url]]];
                }
                
                if(downloadedImage != NULL){
                    [imageCache setObject:downloadedImage forKey:[NSString stringWithFormat:@"%ld-%ld", (long)cellPath.section, (long)cellPath.row]];
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
    [visibleImages removeObjectForKey:[NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row]];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    isScrollingFast = false;
    [_uivPhotos reloadItemsAtIndexPaths:[visibleImages allValues]];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //[collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
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
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    CalendarCollectionViewCell *cell = (CalendarCollectionViewCell*)selectedCell;
    [cell changeSelectedColor:NO];
    
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *image = UIImageJPEGRepresentation(pickedImage, 1.0f);
    
    NSIndexPath *selectedIndexPathCopy = [selectedIndexPath copy];
    
    [self.TakeApi uploadImage:image ForStory:storyInfo.id ForDate:cell.StoryDay.day WithProgressBlock:^(float progress) {
        CalendarCollectionViewCell *uploadingCell = (CalendarCollectionViewCell*)[_uivPhotos cellForItemAtIndexPath:selectedIndexPathCopy];
        if(uploadingCell){
            uploadingCell.StoryDay.uploadProgress = progress;
            [uploadingCell.pbUploadProgress setProgress:progress];
        }
    } WithResultBlock:^(UploadImageResult *result) {
        if(result != NULL){
            //[_uivPhotos reloadItemsAtIndexPaths:@[[_uivPhotos indexPathForCell:cell]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshStoryData];
            });
        }else{
            
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    CalendarCollectionViewCell *cell = (CalendarCollectionViewCell*)selectedCell;
    [cell changeSelectedColor:NO];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SEGUE_SHOW_IMAGE"]){
        PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)selectedCell;
        [segue.destinationViewController setValue:cell.StoryDay.image forKey:@"Image"];
    }
}


@end
