//
//  Utils.swift
//  SpendWithBrain
//
//  Created by Maxim on 28/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    static func saveImageToDocumentDirectory(image : UIImage,name: String) -> String{
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        let imageData = image.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        return name;
    }
    
    static func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let name =  String((0..<60).map{ _ in letters.randomElement()! })
        return name + ".png"
    }
    
    static func deleteDirectory(directoryName : String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(directoryName)
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
        }else{
            print("Directory not found")
        }
    }
    
    static func getImage(imageName : String)-> UIImage{
        let fileManager = FileManager.default
        // Here using getDirectoryPath method to get the Directory path
        let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath) ?? #imageLiteral(resourceName: "chitanta.png")
        }else{
            print("No Image available")
            return #imageLiteral(resourceName: "chitanta.png") // Return placeholder image here
        }
    }
    
    static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func ResizeImage(image: UIImage) -> UIImage {
        let size = image.size
        let targetSize = CGSize(width: 900, height: 900)
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio,height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,height:  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0,width:  newSize.width,height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
