//
//  ClassificationServiceProviding.swift
//  MyDogState
//
//  Created by Francesca Rossi on 05/01/24.
//

import Foundation
import UIKit

protocol ClassificationServiceProviding 
{
    var classificationsResultPub: Published<String>.Publisher { get }
    func updateClassifications(for image: UIImage)
}
