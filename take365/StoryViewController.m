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
#import "MonthCollectionReusableView.h"

@interface StoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation StoryViewController
{
    StoryResult *storyInfo;
    PhotoCollectionViewCell *selectedCell;
    float stockHeight;
    float stockWidth;
    NSMutableDictionary *imageCache;
    NSMutableDictionary *sections;
    NSArray *sortedSectionsTitles;
    
    NSThread *loadingThread;
    NSMutableArray *itemsForLoading;
    
    CGPoint lastOffset;
    NSTimeInterval lastOffsetCapture;
    BOOL isScrollingFast;
    
    NSMutableArray<NSIndexPath*> *visibleImages;
    
    BOOL bigViewEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageCache = [NSMutableDictionary new];
    sections = [NSMutableDictionary new];
    visibleImages = [NSMutableArray new];
    
    [_uivPhotos setDataSource:self];
    [_uivPhotos setDelegate:self];
    
    [[AppDelegate getInstance].api getStoryWithId:_Story.id WithResultBlock:^(StoryResult *result, NSString *error) {
        if(error == NULL){
            storyInfo = result;
            
            for (StoryImageImagesModel *image in result.images) {
                
                NSArray *sectionTitleComponents = [image.date componentsSeparatedByString:@"-"];
                NSString *sectionTitle = [NSString stringWithFormat:@"%@-%@", sectionTitleComponents[0], sectionTitleComponents[1]];
                
                NSMutableArray *sectionContent = [sections objectForKey:sectionTitle];
                
                if(sectionContent == NULL){
                    sectionContent = [NSMutableArray new];
                    [sections setObject:sectionContent forKey:sectionTitle];
                }
                
                [sectionContent addObject:image];
            }
            
            sortedSectionsTitles = [[sections allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString *key1 = obj1;
                NSString *key2 = obj2;
                
                NSDateFormatter *df = [NSDateFormatter new];
                [df setDateFormat:@"yyyy-MM"];
                NSDate *date1 = [df dateFromString:key1];
                NSDate *date2 = [df dateFromString:key2];
                
                if(date1 > date2){
                    return false;
                }else{
                    return true;
                }
            }];
            
            [_uivPhotos reloadData];
        }
    }];
    
    self.title = _Story.title;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"вид" style:UIBarButtonItemStyleDone target:self action:@selector(changeView)];
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
    
    PhotoCollectionViewCell *cell = NULL;
    
    if(bigViewEnabled){
        cell = [_uivPhotos dequeueReusableCellWithReuseIdentifier:@"BigPhotoCollectionViewCell" forIndexPath:indexPath];
    }else{
        cell = [_uivPhotos dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSIndexPath *cellPath = [indexPath copy];
        
        NSString *key = sortedSectionsTitles[indexPath.section];
        NSMutableArray *sectionImages = [sections objectForKey:key];
        StoryImageImagesModel *imageInfo = sectionImages[indexPath.row];
        
        UIImage *image = [imageCache objectForKey:[NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row]];
        if(image == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)[_uivPhotos cellForItemAtIndexPath:cellPath];
                [cell.ivPhoto setHidden:true];
                [cell.aiLoading setHidden:false];
            });
            if(!isScrollingFast){
                if(!bigViewEnabled){
                    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageInfo.thumb.url]]];
                }else{
                    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageInfo.thumbLarge.url]]];
                }
                
                if(image != NULL){
                    [imageCache setObject:image forKey:[NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row]];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(isScrollingFast && image == NULL){
                [visibleImages addObject:indexPath];
                cell.Image = NULL;
                [cell.ivPhoto setImage:NULL];
                cell.lblDay.hidden = true;
                cell.ivPhoto.hidden = true;
                cell.aiLoading.hidden = false;
            }else{
                PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)[_uivPhotos cellForItemAtIndexPath:cellPath];
                cell.Image = imageInfo;
                [cell.ivPhoto setImage:image];
                cell.lblDay.text = [imageInfo.date componentsSeparatedByString:@"-"][2];
                [cell.ivPhoto setHidden:false];
                [cell.aiLoading setHidden:true];
                cell.lblDay.hidden = false;
            }
        });
    });
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [visibleImages removeObject:indexPath];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    isScrollingFast = false;
    [_uivPhotos reloadItemsAtIndexPaths:visibleImages];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    selectedCell = (PhotoCollectionViewCell*)[_uivPhotos cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"SEGUE_SHOW_IMAGE" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SEGUE_SHOW_IMAGE"]){
        [segue.destinationViewController setValue:selectedCell.Image forKey:@"Image"];
    }
}


@end
