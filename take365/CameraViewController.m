//
//  SecondViewController.m
//  take365
//
//  Created by Evgeniy Eliseev on 26.10.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreVideo/CVPixelBufferPool.h>
#import "UIImage+fixOrientation.h"
#import "AppDelegate.h"

@interface CameraViewController ()

@end

@implementation CameraViewController
{
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureVideoPreviewLayer *previewLayer;
    CALayer *rootLayer;
    
    UIImage *image;
    BOOL photoTaken;
    
    UIDeviceOrientation currentOrientation;
    CGFloat currentRotation;
    
    bool blurApplied;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [df setDateFormat:@"LLLL"];
    NSString *month = [df stringFromDate:[NSDate new]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger year = [components year];
    
    _lblYear.text = [@(year) stringValue];
    _lblMonth.text = [NSString stringWithFormat:@"%@ ", month];
    _lblDay.text = [NSString stringWithFormat:@"%d, ",[@(day) intValue]];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
}

-(BOOL)shouldAutorotate {
    return FALSE;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    [self changeViewBasedOnOrientation:device.orientation];
}

-(void)changeViewBasedOnOrientation:(UIDeviceOrientation)orientation
{
    if(currentOrientation != UIDeviceOrientationPortraitUpsideDown && orientation != UIDeviceOrientationPortraitUpsideDown) {
        switch(orientation)
        {
            case UIDeviceOrientationPortrait:
            {
                NSLog(@"Orientation changed to portrait");
                currentRotation = -currentRotation;
            }
                break;
                
            case UIDeviceOrientationLandscapeLeft:
            {
                NSLog(@"Orientation changed to landscape");
                currentRotation = M_PI_2;
            }
                break;
                
            case UIDeviceOrientationLandscapeRight:
            {
                NSLog(@"Orientation changed to landscape");
                currentRotation = -M_PI_2;
            }
                break;
                default:
                break;
        }
        [UIView animateWithDuration:0.5f animations:^{
            [_btnMakeShot setTransform:CGAffineTransformRotate(_btnMakeShot.transform, currentRotation)];
        }];
    }
    currentOrientation = orientation;
}

- (void)applyBlurEffectToView:(UIView*)view{
    [view setBackgroundColor:nil];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:view.bounds];
    [view addSubview:blurEffectView];
    [view sendSubviewToBack:blurEffectView];
}

- (IBAction)btnCancel_Click:(id)sender {
    photoTaken = FALSE;
    
    if(image == NULL) {
        self.TakeApi.imageForUpload = NULL;
        [self dismissViewControllerAnimated:TRUE completion:NULL];
    }
    
    image = NULL;
    self.uivPhotoView.image = NULL;
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    [self.btnMakeShot setTitle:@"take" forState:UIControlStateNormal];
    self.btnMakeShotWidthConstraint.constant = 76;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)btnCapture_Clicked:(id)sender {
    
    if(photoTaken && image == NULL) {
        return;
    }
    
    if(image != NULL) {
        self.TakeApi.imageForUpload = image;
        [self dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    photoTaken = TRUE;
    [self.btnMakeShot setTitle:@"обработка" forState:UIControlStateNormal];
    self.btnMakeShotWidthConstraint.constant = 100;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
    
    AVCaptureConnection *connection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    AVCaptureVideoPreviewLayer *pl = (AVCaptureVideoPreviewLayer *)previewLayer;
    
    // Update the orientation on the still image output video connection before capturing.
    connection.videoOrientation = pl.connection.videoOrientation;
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        
        CGImageRef myImage = [self imageFromSampleBuffer:imageDataSampleBuffer];
        
        switch (currentOrientation) {
            default:
            case UIDeviceOrientationPortrait:
                image = [[UIImage alloc] initWithCGImage:myImage scale:1.0f orientation:UIImageOrientationRight];
                break;
            case UIDeviceOrientationLandscapeLeft:
                image = [[UIImage alloc] initWithCGImage:myImage];
                break;
            case UIDeviceOrientationLandscapeRight:
                image = [[UIImage alloc] initWithCGImage:myImage scale:1.0f orientation:UIImageOrientationDown];
                break;
        }
        
        NSArray *sublayers = rootLayer.sublayers;
        for (CALayer *layer in sublayers) {
            [layer removeFromSuperlayer];
        }
        
        self.uivPhotoView.image = image;
        [self.btnMakeShot setTitle:@"продолжить" forState:UIControlStateNormal];
    }];
}

- (UIImage*) rotateImageAppropriately:(UIImage*)imageToRotate
{
    UIImage* properlyRotatedImage;
    
    CGImageRef imageRef = [imageToRotate CGImage];
    
    if (imageToRotate.imageOrientation == 0)
    {
        properlyRotatedImage = imageToRotate;
    }
    else if (imageToRotate.imageOrientation == 3)
    {
        
        CGSize imgsize = imageToRotate.size;
        UIGraphicsBeginImageContext(imgsize);
        [imageToRotate drawInRect:CGRectMake(0.0, 0.0, imgsize.width, imgsize.height)];
        properlyRotatedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else if (imageToRotate.imageOrientation == 1)
    {
        properlyRotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:1];
    }
    
    return properlyRotatedImage;
}

- (CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer // Create a CGImageRef from sample buffer data
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);        // Lock the image buffer
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CGContextRelease(newContext);
    
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    /* CVBufferRelease(imageBuffer); */  // do not call this!
    
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    
    currentOrientation = [UIDevice currentDevice].orientation;
    if(currentOrientation != UIDeviceOrientationPortrait && currentOrientation != UIDeviceOrientationPortraitUpsideDown){
        [self changeViewBasedOnOrientation:currentOrientation];
    }
    
    if(session == NULL){
        session = [AVCaptureSession new];
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
        
        AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
        
        if([session canAddInput:deviceInput]){
            [session addInput:deviceInput];
        }
        
        previewLayer =  [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        rootLayer = [[self uivPhotoView] layer];
        [rootLayer setMasksToBounds:YES];
        
        CGRect frame = self.uivPhotoView.bounds;
        [previewLayer setFrame:frame];
        [rootLayer insertSublayer:previewLayer atIndex:0];
        
        stillImageOutput = [AVCaptureStillImageOutput new];
        
        NSNumber * pixelFormat = [NSNumber numberWithInt:kCVPixelFormatType_32BGRA];
        [stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:pixelFormat
                                                                        forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        
        [session addOutput:stillImageOutput];
        
        if(!session.isRunning){
            [session startRunning];
        }
    }

}

-(void)viewDidDisappear:(BOOL)animated{
    //[session stopRunning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SEGUE_PUBLISH_PHOTO"]){
        [segue.destinationViewController setValue:image forKey:@"Image"];
    }
}

@end
