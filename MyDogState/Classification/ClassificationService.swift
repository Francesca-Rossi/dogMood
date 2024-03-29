//
//  ClassificationService.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/01/24.
//

import Foundation
import Vision
import UIKit

final class ClassificationService: ClassificationServiceProviding {
    
    //@Published private var classifications: String = ""
    @Published private var classifications: [PredictionResult] = [PredictionResult]()
    
    var classificationsResultPub: Published<[PredictionResult]>.Publisher { $classifications }
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: DogEmotionImageClassification(configuration: MLModelConfiguration()).model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            request.usesCPUOnly = true
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    
    // MARK: - Image Classification
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        let orientation = CGImagePropertyOrientation( image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        /// Clear old classifications
        self.classifications = [PredictionResult]()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the variable with the results of the classification.
    /// - Tag: ProcessClassifications
    private func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            //let predictionResultList: [PredictionResult]
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                // do nothing
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(5)
                for item in topClassifications
                {
                    self.classifications.append(PredictionResult(confidence: item.confidence, identifier: item.identifier))
                }
            }
        }
    }
}

extension CGImagePropertyOrientation {
    /**
     Converts a `UIImageOrientation` to a corresponding
     `CGImagePropertyOrientation`. The cases for each
     orientation are represented by different raw values.
     
     - Tag: ConvertOrientation
     */
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}
