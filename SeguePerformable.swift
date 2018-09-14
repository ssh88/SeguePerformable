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
    typealias SegueCompletionBlock<T: UIViewController> = (UIStoryboardSegue, T) -> Void
}

extension SeguePerformable where Self: UIViewController, SegueIdentifier.RawValue == String {

     /**
     Performs a segue navigation with a completion block
     */
    func performSegue<T: UIViewController>(_ type: T.Type,_ segueIdentifier: SegueIdentifier, completion: SegueCompletionBlock<T>? = nil) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: completion)
    }
    
    /**
     Checks if the sender param on the prepare(for segue:sender:) function is of type SegueCompletionBlock
     */
    func senderIsSegueCompletionBlock(_ sender: Any?, _ segue: UIStoryboardSegue) -> Bool {
        guard let completion = sender as? SegueCompletionBlock else { return false }
        completion(segue, segue.destination)
        return true
    }
    
    /**
     Fetches the segue id for a given storyboard and returns its as an enum value
     */
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard
            let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else {
                fatalError("Invalid segue identifier \(String(describing: segue.identifier))")
        }
        
        return segueIdentifier
    }
}
