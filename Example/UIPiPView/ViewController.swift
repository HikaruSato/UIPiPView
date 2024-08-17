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

    @IBOutlet weak var pipView2: UIPiPView!
    @IBOutlet weak var pipView2Label: UILabel!
    
    private let pipView = UIPiPView()
    private let startButton = UIButton()
    private let timeLabel = UILabel()

    private var timer: Timer!
    private let formatter = DateFormatter()
    private var count: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()


        pipView2.removeFromSuperview()
        let window = (UIApplication.shared.delegate as! AppDelegate).window!
        window.addSubview(pipView2)
        window.sendSubviewToBack(pipView2)
        pipView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pipView2.topAnchor.constraint(equalTo: window.topAnchor, constant: 280),
            pipView2.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
            pipView2.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
            pipView2.heightAnchor.constraint(equalToConstant: 50)
        ])


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

        /// PiP View
        pipView.frame = .init(x: margin, y: 160, width: width, height: 40)
        pipView.backgroundColor = .black
        self.view.addSubview(pipView)

        /// Time Label on PiPView
        timeLabel.frame = .init(x: 10, y: 0, width: width - 20, height: 40)
        timeLabel.textColor = .white
        pipView.addSubview(timeLabel)

        if #available(iOS 13.0, *) {
            timeLabel.font = .monospacedSystemFont(ofSize: 30, weight: .medium)
            timeLabel.adjustsFontSizeToFitWidth = true
        }

        /// Time Label  shows now.
        formatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        timer = Timer(timeInterval: (0.1 / 60.0), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeLabel.text = self.formatter.string(from: Date())
            self.pipView2Label.text = count.description
            self.count += 1
        }
        RunLoop.main.add(timer, forMode: .default)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc func toggle() {
        let pipView = pipView2!
        if (!pipView.isPictureInPictureActive()) {
            pipView.startPictureInPicture(withRefreshInterval: (0.1 / 60.0))
        } else {
            pipView.stopPictureInPicture()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func appMovedToBackground() {
        if (!pipView.isPictureInPictureActive()) {
            pipView.startPictureInPicture(withRefreshInterval: (0.1 / 60.0))
        }
    }
    
    @IBAction func didTapShowModal(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.modalPresentationStyle = .fullScreen
        vc.startPip = { [weak self] in
            guard let self else { return }
            if (!self.pipView2.isPictureInPictureActive()) {
                self.pipView2.startPictureInPicture(withRefreshInterval: (0.1 / 60.0))
            }
        }
        present(vc, animated: true)
    }
}

