//
//  IGVideoPlayerView.swift
//  IGLocation
//
//  Created by Jesus De Meyer on 30/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import UIKit
import AVKit

class IGVideoPlayerView: UIView {
    var url: URL? {
        didSet {
            //self.updatePlayer()
        }
    }
    var autoplay = true
    var loop = true

    fileprivate(set) var player: AVPlayer!

    fileprivate lazy var playerLayer: AVPlayerLayer = {
        return AVPlayerLayer(player: nil)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.removeObserver(self, forKeyPath: "bounds", context: nil)
    }

    fileprivate func setup() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
            if self.loop {
                self.player.seek(to: kCMTimeZero)
                self.player.play()
            }
        }

        self.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }

    fileprivate func updatePlayer() {
        guard let theURL = url else {
            return
        }

        let player = AVPlayer(url: theURL)
        playerLayer.player = player
        self.player = player

        if let doomedLayer = playerLayer.superlayer {
            doomedLayer.removeFromSuperlayer()
        }

        self.layer.addSublayer(playerLayer)

        playerLayer.frame = self.bounds

        if autoplay {
            player.play()
        }
    }

    func attach(to otherView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false

        otherView.addSubview(self)

        otherView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self]))
        otherView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self]))

        self.updatePlayer()
    }

    func overlay(on otherView: UIView) {
        guard let superview = otherView.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        superview.addSubview(self)

        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: otherView, attribute: .left, multiplier: 1.0, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: otherView, attribute: .right, multiplier: 1.0, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: otherView, attribute: .top, multiplier: 1.0, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: otherView, attribute: .bottom, multiplier: 1.0, constant: 0))

        self.updatePlayer()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "bounds") {
            self.playerLayer.frame = self.bounds
        }
    }
}
