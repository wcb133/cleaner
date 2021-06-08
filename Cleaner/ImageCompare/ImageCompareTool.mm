//
//  ImageCompare.m
//  合并两个有序链表
//
//  Created by 谢佳培 on 2020/7/31.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ImageCompareTool.h"
#import <opencv2/opencv.hpp>
#import "sys/utsname.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

//方差参考值
const double delta = 10;

@implementation ImageCompareTool

// 是否相似
+ (BOOL)isImage:(UIImage *)image1 likeImage:(UIImage *)image2 {
    cv::Mat mat1 = [self cvMatFromUIImage:image1];
    cv::Mat mat2 = [self cvMatFromUIImage:image2];
    return  aHash(mat1, mat2) <= 5;
}

//获取相似度
int aHash(cv::Mat matSrc1, cv::Mat matSrc2)
{
    cv::Mat matDst1, matDst2;
    cv::resize(matSrc1, matDst1, cv::Size(8, 8), 0, 0, cv::INTER_CUBIC);
    cv::resize(matSrc2, matDst2, cv::Size(8, 8), 0, 0, cv::INTER_CUBIC);
 
    cv::cvtColor(matDst1, matDst1, CV_BGR2GRAY);
    cv::cvtColor(matDst2, matDst2, CV_BGR2GRAY);
 
    int iAvg1 = 0, iAvg2 = 0;
    int arr1[64], arr2[64];
 
    for (int i = 0; i < 8; i++)
    {
        uchar* data1 = matDst1.ptr<uchar>(i);
        uchar* data2 = matDst2.ptr<uchar>(i);
 
        int tmp = i * 8;
 
        for (int j = 0; j < 8; j++)
        {
            int tmp1 = tmp + j;
 
            arr1[tmp1] = data1[j] / 4 * 4;
            arr2[tmp1] = data2[j] / 4 * 4;
 
            iAvg1 += arr1[tmp1];
            iAvg2 += arr2[tmp1];
        }
    }
 
    iAvg1 /= 64;
    iAvg2 /= 64;
 
    for (int i = 0; i < 64; i++)
    {
        arr1[i] = (arr1[i] >= iAvg1) ? 1 : 0;
        arr2[i] = (arr2[i] >= iAvg2) ? 1 : 0;
    }
 
    int iDiffNum = 0;
 
    for (int i = 0; i < 64; i++)
        if (arr1[i] != arr2[i])
            ++iDiffNum;
 
    return iDiffNum;
}


// 缩小尺寸
+ (UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size {
    // size 为CGSize类型，即你所需要的图片尺寸
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// 单通道彩色图片的直方图
+ (double)CompareHistSignle:(IplImage*)image1 withParam2:(IplImage*)image2 {
    int hist_size = 256;
    CvHistogram *gray_hist = cvCreateHist(1, &hist_size, CV_HIST_ARRAY);
    cvCalcHist(&image1, gray_hist);
    
    CvHistogram *gray_hist2 = cvCreateHist(1, &hist_size, CV_HIST_ARRAY);
    cvCalcHist(&image2, gray_hist2);
    
    return cvCompareHist(gray_hist, gray_hist2, CV_COMP_BHATTACHARYYA);
}

// 进行肤色检测
+ (void)SkinDetect:(IplImage*)src withParam:(IplImage*)dst {
    // 创建图像头
    // 用于存图像的一个中间变量，是用来分通道用的，分成hsv通道
    IplImage* hsv = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 3);
    // 通道的中间变量，用于肤色检测的中间变量
    IplImage* tmpH1 = cvCreateImage( cvGetSize(src), IPL_DEPTH_8U, 1);
    IplImage* tmpS1 = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
    IplImage* tmpH2 = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
    IplImage* tmpS2 = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
    IplImage* tmpH3 = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
    IplImage* tmpS3 = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
    IplImage* H = cvCreateImage( cvGetSize(src), IPL_DEPTH_8U, 1);
    IplImage* S = cvCreateImage( cvGetSize(src), IPL_DEPTH_8U, 1);
    IplImage* V = cvCreateImage( cvGetSize(src), IPL_DEPTH_8U, 1);
    IplImage* src_tmp1=cvCreateImage(cvGetSize(src),8,3);
    
    // 高斯模糊
    cvSmooth(src,src_tmp1,CV_GAUSSIAN,3,3);
    
    // hue色度，saturation饱和度，value纯度
    cvCvtColor(src_tmp1, hsv, CV_BGR2HSV );
    // 分为3个通道
    cvSplit(hsv,H,S,V,0);
    
    /*********************肤色检测部分**************/
    cvInRangeS(H,cvScalar(0.0,0.0,0,0),cvScalar(20.0,0.0,0,0),tmpH1);
    cvInRangeS(S,cvScalar(75.0,0.0,0,0),cvScalar(200.0,0.0,0,0),tmpS1);
    cvAnd(tmpH1,tmpS1,tmpH1,0);
    
    // Red Hue with Low Saturation
    // Hue 0 to 26 degree and Sat 20 to 90
    cvInRangeS(H,cvScalar(0.0,0.0,0,0),cvScalar(13.0,0.0,0,0),tmpH2);
    cvInRangeS(S,cvScalar(20.0,0.0,0,0),cvScalar(90.0,0.0,0,0),tmpS2);
    cvAnd(tmpH2,tmpS2,tmpH2,0);
    
    // Red Hue to Pink with Low Saturation
    // Hue 340 to 360 degree and Sat 15 to 90
    cvInRangeS(H,cvScalar(170.0,0.0,0,0),cvScalar(180.0,0.0,0,0),tmpH3);
    cvInRangeS(S,cvScalar(15.0,0.0,0,0),cvScalar(90.,0.0,0,0),tmpS3);
    cvAnd(tmpH3,tmpS3,tmpH3,0);
    
    // Combine the Hue and Sat detections
    cvOr(tmpH3,tmpH2,tmpH2,0);
    cvOr(tmpH1,tmpH2,tmpH1,0);
    cvCopy(tmpH1,dst);
    cvReleaseImage(&hsv);
    cvReleaseImage(&tmpH1);
    cvReleaseImage(&tmpS1);
    cvReleaseImage(&tmpH2);
    cvReleaseImage(&tmpS2);
    cvReleaseImage(&tmpH3);
    cvReleaseImage(&tmpS3);
    cvReleaseImage(&H);
    cvReleaseImage(&S);
    cvReleaseImage(&V);
    cvReleaseImage(&src_tmp1);
}

// UIImage类型转换为IPlImage类型
+ (IplImage*)convertToIplImage:(UIImage*)image {
    CGImageRef imageRef = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    IplImage *iplImage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
    CGContextRef contextRef = CGBitmapContextCreate(iplImage->imageData, iplImage->width, iplImage->height, iplImage->depth, iplImage->widthStep, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
//    CGImageRelease(imageRef);
    
    IplImage *ret = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplImage, ret, CV_RGB2BGR);
    cvReleaseImage(&iplImage);
    
    return ret;
}

// IplImage类型转换为UIImage类型
+ (UIImage*)convertToUIImage:(IplImage*)image {
    cvCvtColor(image, image, CV_BGR2RGB);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(image->width, image->height, image->depth, image->depth * image->nChannels, image->widthStep, colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}


//判断图片模糊相关
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {//可以根据这个决定使用哪种
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}



+ (BOOL) isImageFuzzy:(UIImage*)image{
    
    unsigned char *data;
    int height,width,step;
    
    int Iij;
    
    double Iave = 0, Idelta = 0;
    
    cv::Mat mat = [self cvMatFromUIImage:image];
    
    if(!mat.empty()){
        cv::Mat gray;
        cv::Mat outGray;
        // 将图像转换为灰度显示
        cv::cvtColor(mat,gray,CV_RGB2GRAY);
        // 用openCV的Laplacian函数做灰度图做拉普拉斯计算，得到outGray
        cv::Laplacian(gray, outGray, gray.depth());
        //将得到的outGray转化为图片信息类IplImage
        IplImage ipl_image(outGray);
        
        data   = (uchar*)ipl_image.imageData;  //图片像素信息
        height = ipl_image.height;             //图片像素高度
        width  = ipl_image.width;              //图片像素宽度
        step   = ipl_image.widthStep;          //排列的图像行大小，以字节为单位
        
        for(int i=0;i<height;i++){    //求方差
            for(int j=0;j<width;j++)
            {
                Iij    = (int) data
                [i*width+j];
                Idelta    = Idelta + (Iij-Iave)*(Iij-Iave);
            }
        }
        Idelta = Idelta/(width*height);
        
//        std::cout<<"矩阵方差为："<<Idelta<<std::endl;
    }
    
    return (Idelta < delta) ? YES : NO;
}

// 获取设备型号然后手动转化为对应名称
- (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone12,8"])   return @"iPhone SE 2";
    if ([deviceString isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,5"])     return @"iPad 6th generation";
    if ([deviceString isEqualToString:@"iPad7,6"])     return @"iPad 6th generation";
    if ([deviceString isEqualToString:@"iPad8,1"])     return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,2"])     return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,3"])     return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,4"])     return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,5"])     return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad8,6"])     return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad8,7"])     return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad8,8"])     return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad8,9"])     return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,10"])   return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,11"])   return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad8,12"])   return @"iPad Pro (12.9-inch)";

    
   if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
   if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
   if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
   if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";

    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}
 
// 计算开机时间
-(NSString *) bootTime {
    struct timeval t;
    size_t len=sizeof(struct timeval);
    if(sysctlbyname("kern.boottime",&t,&len,0,0)!=0)
        return @"0.0";
    NSTimeInterval time = t.tv_sec+t.tv_usec/USEC_PER_SEC;
    return [self timeIntervalToFormat:time];
}

// 类型转化
- (NSString *)timeIntervalToFormat:(NSTimeInterval)localTimeInterval{
    time_t timeInterval = (time_t)localTimeInterval;
    struct tm *time = localtime(&timeInterval);
    NSString *timeStr = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d:%02d",time->tm_year + 1900,time->tm_mon + 1,time->tm_mday,time->tm_hour,time->tm_min, time->tm_sec];
    return timeStr;
}

@end
