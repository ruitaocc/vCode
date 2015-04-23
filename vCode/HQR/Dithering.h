#pragma  once


#import <opencv2/opencv.hpp>
#import <opencv2/highgui/highgui_c.h>
#import <Availability.h>

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

#ifdef  __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif
void DitheringHalftone(IplImage *I,int A []);
template <typename T>
T clamp_d(const T& value, const T& low, const T& high) {
	return value < low ? low : (value > high ? high : value);
}
