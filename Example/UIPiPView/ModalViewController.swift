//
//  ModalViewController.swift
//  UIPiPView_Example
//
//  Created by Hikaru Sato on 2024/08/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

final class ModalViewController: UIViewController {

    var startPip: (()-> Void)?
    var didDismiss: (()-> Void)?

    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.didDismiss?()
        }
    }

    @IBAction func didTapStartPip(_ sender: Any) {
        startPip?()
    }
    
}
