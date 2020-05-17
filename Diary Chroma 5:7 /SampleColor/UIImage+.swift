//
//  UIImage+.swift
//  SampleColor
//
//  Created by Nien Lam on 4/14/20.
//  Copyright © 2020 Mobile Lab. All rights reserved.
//

//import Foundation
//import UIKit
//
//extension UIImage {
//    func getPixelColor(pos: CGPoint) -> UIColor {
//
//        let pixelData = self.cgImage!.dataProvider!.data
//        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
//
//        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
//
//        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
//        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
//        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
//        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
//        //print("red", r, "green", g, "blue", b)
//
//        return UIColor(red: r, green: g, blue: b, alpha: a)
//    }
//}



import UIKit

extension UIImage {
    func getPixelColor(point: CGPoint) -> UIColor? {
        guard let cgImage = cgImage,
            let pixelData = cgImage.dataProvider?.data
            else { return nil }
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let alphaInfo = cgImage.alphaInfo
        assert(alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst, "This routine expects alpha to be first component")
        
        let byteOrderInfo = cgImage.byteOrderInfo
        assert(byteOrderInfo == .order32Little || byteOrderInfo == .orderDefault, "This routine expects little-endian 32bit format")
        
        let bytesPerRow = cgImage.bytesPerRow
        let pixelInfo = Int(point.y) * bytesPerRow + Int(point.x) * 4;
        
        let a: CGFloat = CGFloat(data[pixelInfo+3]) / 255
        let r: CGFloat = CGFloat(data[pixelInfo+2]) / 255
        let g: CGFloat = CGFloat(data[pixelInfo+1]) / 255
        let b: CGFloat = CGFloat(data[pixelInfo  ]) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
