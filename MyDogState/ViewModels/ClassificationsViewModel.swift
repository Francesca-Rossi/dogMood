//
//  CheckEmotionalDogStateContentViewModel.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/01/24.
//

import Combine
import UIKit

@MainActor
final class ClassificationsViewModel: ObservableObject {
    @Published var displayImagePicker: Bool = false
    
    @Published var importedImage: UIImage? = nil
    
    @Published var classifications: [PredictionResult] = [PredictionResult]()
    
    let service: ClassificationServiceProviding
    
    private var subscribers: [AnyCancellable] = []
    
    init(
        image: UIImage? = nil,
        service: ClassificationServiceProviding = ClassificationService()
    ) {
        self.importedImage = image
        self.service = service
        
        self.subscribe()
        self.onChangeImage()
    }
    
    func subscribe() {
        self.service.classificationsResultPub
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newClassifications in
                self?.classifications = newClassifications
            }
            .store(in: &subscribers)
    }
    
    func onChangeImage() {
        guard let image = importedImage else { return }
        service.updateClassifications(for: image)
    }
    
}

