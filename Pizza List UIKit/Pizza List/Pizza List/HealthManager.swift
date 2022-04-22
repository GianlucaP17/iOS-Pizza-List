//
//  HealthManager.swift
//  PizzaList
//
//  Created by Gianluca Posca
//  Copyright (c) Gianluca Posca. All rights reserved.
//

import UIKit
import HealthKit

class HealthManager {
    
    static let shared = HealthManager()

    var healthStore : HKHealthStore!
    
    func setupHealthStore() {
        healthStore = HKHealthStore()
        impostaPermessiHealthBook()
    }
    
    func impostaPermessiHealthBook() {
        
        if HKHealthStore.isHealthDataAvailable() {
            
            let shareSet = Set<HKSampleType>([HKSampleType.quantityType(forIdentifier: .dietaryEnergyConsumed)!])
            
            healthStore.requestAuthorization(toShare: shareSet,
                                             read: nil,
                                             completion: { (success, error) in
                    if success {
                        print("Permessi HealthBook OK")
                    } else {
                        print(error?.localizedDescription as Any)
                    }    
            })
        }
    }
    
    func aggiungiCalorie(nome : String, calorie : Double, closure: @escaping ()->()) {
		
		guard let hkqt = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {  return }
		
        let calorieSamplePro = HKQuantitySample(type: hkqt,
            quantity: HKQuantity(unit: HKUnit.smallCalorie(), doubleValue: calorie),
            start: Date(),
            end: Date(),
            metadata: [HKMetadataKeyFoodType:nome])
        
        healthStore.save(calorieSamplePro) { (success, error) in
            if success {
                closure()
            } else {
                print(error!)
            }
        }
    }
}
