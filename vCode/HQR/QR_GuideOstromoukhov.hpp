#pragma  once

//#include <cv.h>
#include <opencv2/opencv.hpp>

#include "OstrHeader.hpp"
IplImage *QR_Guide_OstromoukhovHalftone(IplImage *I,IplImage *Qr);

template <typename T>
T clamp2(const T& value, const T& low, const T& high) {
	return value < low ? low : (value > high ? high : value);
}
