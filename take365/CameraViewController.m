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


@interface CameraViewController ()

@end

@implementation CameraViewController
{
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureVideoPreviewLayer *previewLayer;
    
    UIImage *image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self applyBlurEffectToView:_topBarView];
    [self applyBlurEffectToView:_bottmBarView];
    
    [_topBarView bringSubviewToFront:_lblTake];
    [_topBarView bringSubviewToFront:_svDate];
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [df setDateFormat:@"MMMM"];
    NSString *month = [df stringFromDate:[NSDate new]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger year = [components year];
    
    _lblYear.text = [@(year) stringValue];
    _lblMonth.text = [NSString stringWithFormat:@"%@ ", month];
    _lblDay.text = [NSString stringWithFormat:@"%d, ",[@(day) intValue]];
}

- (void)applyBlurEffectToView:(UIView*)view{
    [view setBackgroundColor:nil];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:view.bounds];
    [view addSubview:blurEffectView];
    [view sendSubviewToBack:blurEffectView];
}

- (IBAction)btnCapture_Clicked:(id)sender {
    
    AVCaptureConnection *connection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    AVCaptureVideoPreviewLayer *pl = (AVCaptureVideoPreviewLayer *)previewLayer;
    
    // Update the orientation on the still image output video connection before capturing.
    connection.videoOrientation = pl.connection.videoOrientation;
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        CGImageRef myImage = [self imageFromSampleBuffer:imageDataSampleBuffer];
        
        image = [[UIImage alloc] initWithCGImage:myImage scale:1.0f orientation:UIImageOrientationRight];
        
        [self performSegueWithIdentifier:@"SEGUE_PUBLISH_PHOTO" sender:self];
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
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{

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
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        CALayer *rootLayer = [[self view] layer];
        [rootLayer setMasksToBounds:YES];
        
        CGRect frame = self.view.frame;
        
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
