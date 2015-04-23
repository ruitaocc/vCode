#include "Ostromoukhov.hpp"
#include <vector>
#include <algorithm>

using namespace std;

static double d(int i, int j) {
    double res;
    if (i > 127) i = 255 - i;
    res = table[i][j] / (table[i][0] + table[i][1] + table[i][2]);
    return res;
}

static double d10(int i) {
    return d(i,0);
}

static double d_11(int i) {
    return d(i,1);
}

static double d01(int i) {
    return d(i,2);
}

static double mround(double d)
{
    return floor(d + 0.5);
}
static bool isQrPoint(int i, int j,int size){
    int scale = size/3;
    i = i/scale;
    j = j/scale;
    return ((i%3)==1)&&((j%3)==1);
}

IplImage *OstromoukhovHalftone(IplImage *I) {
	vector<double> vd; vd.reserve(I->width * I->height);
	for (int i = 0; i < I->width * I->height; i++) {
		vd.push_back(cvGet1D(I, i).val[0]);
	}
	sort(vd.begin(), vd.end());
	reverse(vd.begin(), vd.end());
	double avgLum = cvAvg(I).val[0];//average lumination
	//int idx = mround(avgLum * I->width * I->height);
	//double thres = vd[idx];
	//printf("%lf %lf\n", thres, avgLum);
	IplImage *temp = cvCloneImage(I);
	IplImage *res = cvCloneImage(I);
	cvZero(res);
	for (int i = 0; i < I->height; i++) {
		for (int j = 0; j < I->width; j++) {
			double error = 0.;
			double val = cvGet2D(temp,i,j).val[0];
			//val = clamp(val, 0., 1.);
			if (val > avgLum) {
				cvSet2D(res, i, j, cvScalar(1));
				error = val - 1.;
			}
			else {
				cvSet2D(res, i, j, cvScalar(0));
				error = val;
			}
			int level = mround(val*255.0);
			level = clamp(level, 0, 255);

			if(j==0 && (i!=(I->height-1))){
				(CV_IMAGE_ELEM(temp, double, i, j + 1)) += error *d10(level);
				(CV_IMAGE_ELEM(temp, double, i + 1, j)) += error *d01(level);
			}else if((i!=(I->height-1))&&(j!=(I->width-1))){
				(CV_IMAGE_ELEM(temp, double, i, j + 1)) += error *d10(level);
				(CV_IMAGE_ELEM(temp, double, i + 1, j - 1)) += error *d_11(level);
				(CV_IMAGE_ELEM(temp, double, i + 1, j)) += error *d01(level);
			}else if((i==(I->height-1))&&(j==(I->width-1))){
				continue;
			}else if(i==(I->height-1)){
				(CV_IMAGE_ELEM(temp, double, i, j + 1)) += error *d10(level);
			}else if(j==(I->width-1)){
				(CV_IMAGE_ELEM(temp, double, i + 1, j - 1)) += error *d_11(level);
				(CV_IMAGE_ELEM(temp, double, i + 1, j)) += error *d01(level);
			}
		}
	}
	//printf("%lf", cvAvg(res).val[0]);
	cvReleaseImage(&temp);
	return res;
}
