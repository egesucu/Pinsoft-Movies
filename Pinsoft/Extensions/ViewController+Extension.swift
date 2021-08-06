//
//  ViewController+Extension.swift
//  Pinsoft
//
//  Created by Ege Sucu on 6.08.2021.
//

import UIKit


extension UIViewController {
    
    func createAlert(context: String) {
        let alert = UIAlertController(title: "Error", message: context, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
