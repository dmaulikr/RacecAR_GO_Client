//
//  RoIExtractor.m
//  RacecARGO
//
//  Created by Johannes Heucher on 03.02.17.
//  Copyright © 2017 Johannes Heucher. All rights reserved.
//

#import "RoIExtractor.h"


#define ROI_TOP_FACTOR 0.7
#define ROI_BOTTOM_FACTOR 0.1
#define ROI_LEFT_FACTOR 0.6
#define ROI_RIGHT_FACTOR 0.6


@implementation RoIExtractor

+ (cv::Mat)extractFromSource:(cv::Mat&)src withNumberPlateRect:(cv::Rect&)rect {
    int w = rect.width;
    int h = rect.height;
    
    int rowStart = (int)MAX(rect.y - ROI_TOP_FACTOR * w, 0);
    int rowEnd   = (int)MIN(rect.y + h + ROI_BOTTOM_FACTOR * w, src.rows - 1);
    
    int colStart = (int)MAX(rect.x - ROI_LEFT_FACTOR * w, 0);
    int colEnd   = (int)MIN(rect.x + w + ROI_RIGHT_FACTOR * w, src.cols - 1);
    
    cv::Mat submat = cv::Mat(src, cv::Range(rowStart, rowEnd), cv::Range(colStart, colEnd));
    
    // delete content of number plate
    cv::Point p(rect.x - colStart, rect.y - rowStart);
    cv::Point q(rect.x + rect.width - colStart, rect.y + rect.height - rowStart);
    cv::rectangle(submat, p, q, cv::Scalar(0));
    
    return submat;
}

@end
