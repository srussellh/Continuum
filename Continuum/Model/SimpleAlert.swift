//
//  SimpleAlert.swift
//  Continuum
//
//  Created by Bobba Kadush on 6/6/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
extension UIViewController {
    func presentSimpleAlertWith(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}
