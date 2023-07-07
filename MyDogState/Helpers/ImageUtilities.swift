//
//  ImageUtilities.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/07/23.
//

import Foundation
import SwiftUI

public class ImageUtilities
{
    private var image: UIImage?
    
    init(image: UIImage?)
    {
        self.image = image
    }
    
    private func convertImagetoDataFromJPEG() -> Data?
    {
        return image?.jpegData(compressionQuality: 80.0)
    }
    
    private func convertImagetoDataFromPNG() -> Data?
    {
        return image?.pngData()
    }
    
    public func convertImageToData(error: inout ErrorInfo) throws -> Data?
    {
        if let data = convertImagetoDataFromPNG()
        {
            return data
        }
        else if let data = convertImagetoDataFromJPEG()
        {
            return data
        }
        else
        {
            error.setErrorMessage(value: "Image file not supported")
            throw error
        }
    }
    
    
}
