//
//  ImageSaver.swift
//  ImportPictureExample
//
//  Created by Manoel Leal on 29/06/22.
//

import UIKit

class ImageSaver: NSObject{
    func writeToPhotoAlbum(image: UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        print("Save finished!")
    }
}
