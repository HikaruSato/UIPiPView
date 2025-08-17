//
//  ViewController.swift
//  UIPiPView
//
//  Created by Akihiro Urushiara on 12/12/2021.
//  Copyright (c) 2021 Akihiro Urushiara. All rights reserved.
//

import UIKit
import UIPiPView

class ViewController: UIViewController {

    @IBOutlet weak var pipView: UIPiPView!
    @IBOutlet weak var pipViewLabel: UILabel!

    private let startButton = UIButton()
    private let timeLabel = UILabel()

    private var timer: Timer!
    private let formatter = DateFormatter()
    private var count: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        let window = (UIApplication.shared.delegate as! AppDelegate).window!


        pipView.removeFromSuperview()

        window.addSubview(pipView)
        window.sendSubviewToBack(pipView)
        pipView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pipView.topAnchor.constraint(equalTo: window.topAnchor, constant: 280),
            pipView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
            pipView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
            pipView.heightAnchor.constraint(equalToConstant: 50)
        ])
        pipView.startPiPRender()

        let width = CGFloat(240)
        /// Start Button
        let margin = ((self.view.bounds.width - width) / 2)
        startButton.frame = .init(x: margin, y: 80, width: width, height: 40)
        startButton.addTarget(self, action: #selector(ViewController.toggle), for: .touchUpInside)
        startButton.setTitle("Toggle PiP", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.backgroundColor = .white
        startButton.layer.cornerRadius = 10
        self.view.addSubview(startButton)

        /// Time Label on PiPView
        timeLabel.frame = .init(x: 10, y: 0, width: width - 20, height: 40)
        timeLabel.textColor = .white

        if #available(iOS 13.0, *) {
            timeLabel.font = .monospacedSystemFont(ofSize: 30, weight: .medium)
            timeLabel.adjustsFontSizeToFitWidth = true
        }



        /// Time Label  shows now.
        formatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeLabel.text = self.formatter.string(from: Date())
            self.pipViewLabel.text = count.description
            self.count += 1
            self.pipView.render()
            self.pipView.becomeFirstResponder()
            window.becomeFirstResponder()
        }
        RunLoop.main.add(timer, forMode: .default)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func toggle() {
        let pipView = pipView!
        if (!pipView.isPictureInPictureActive()) {
            pipView.startPictureInPicture(withRefreshInterval: 60.0)
        } else {
            pipView.stopPictureInPicture()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTapShowModal(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.modalPresentationStyle = .fullScreen
        vc.startPip = { [weak self] in
            guard let self else { return }
            if (!self.pipView.isPictureInPictureActive()) {
                self.pipView.startPictureInPicture(withRefreshInterval: 60.0)
            }
        }
        present(vc, animated: true)
    }
}

