//
//  SeguePerformable.swift
//  SeguePerformable
//
//  Created by Shabeer Hussain on 17/11/2016.
//  Copyright © 2016 Desert Monkey. All rights reserved.
//

import Foundation
import UIKit

protocol SeguePerformable {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SeguePerformable where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    /**
    Shadows the stock view controller performSegue function, instead taking in a
    SegueIdentifier enum rather than raw string
    */
    func performSegue(_ segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    /**
    Fetches the segue id for a given storyboard and returns its as an enum value
    */
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        
        guard
            let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else {
                fatalError("Invalid segue identifier \(segue.identifier)")
        }
        
        return segueIdentifier
    }
}
