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
    typealias SegueCompletionBlock = (UIStoryboardSegue, UIViewController) -> Void
}

extension SeguePerformable where Self: UIViewController, SegueIdentifier.RawValue == String {

    func performSegue(_ segueIdentifier: SegueIdentifier, completion: SegueCompletionBlock? = nil) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: completion)
    }

    func senderIsSegueCompletionBlock(_ sender: Any?, _ segue: UIStoryboardSegue) -> Bool {

        guard let completion = sender as? SegueCompletionBlock else {
            return false
        }
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
