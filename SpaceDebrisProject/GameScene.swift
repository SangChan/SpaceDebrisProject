//
//  GameScene.swift
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2017. 7. 22..
//  Copyright © 2017년 LeeSangchan. All rights reserved.
//

import Foundation

extension GameScene {
    func getBluredScreen() -> UIImage {
        guard let view = self.view else { return UIImage() }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let ss = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
    }
    /*
 - (UIImage *)getBluredScreenshot {
 UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1);
 [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
 UIImage *ss = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
 [gaussianBlurFilter setDefaults];
 [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[ss CGImage]] forKey:kCIInputImageKey];
 [gaussianBlurFilter setValue:@5 forKey:kCIInputRadiusKey];
 CIImage *outputImage = [gaussianBlurFilter outputImage];
 CIContext *context = [CIContext contextWithOptions:nil];
 CGRect rect = [outputImage extent];
 rect.origin.x += (rect.size.width - ss.size.width ) / 2;
 rect.origin.y += (rect.size.height - ss.size.height) / 2;
 rect.size = ss.size;
 CGImageRef cgimg = [context createCGImage:outputImage fromRect:rect];
 UIImage *image = [UIImage imageWithCGImage:cgimg];
 CGImageRelease(cgimg);
 return image;
 }
*/
}
