//
//  IGGalleryDetailViewController.swift
//  IGLocation
//
//  Created by Jesus De Meyer on 15/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class IGGalleryDetailViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    var media: IGMedia?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.delegate = self

        if let theMedia = media {
            if theMedia.type == .image {
                self.imageView.sd_setImage(with: theMedia.url, completed: nil)
            } else {
                let playerView = UIView(frame: .zero)
                playerView.translatesAutoresizingMaskIntoConstraints = false

                self.view.addSubview(playerView)

                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[playerView]-0-|", options: [], metrics: nil, views: ["playerView": playerView]))
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playerView]-0-|", options: [], metrics: nil, views: ["playerView": playerView]))

                let player = AVPlayer(url: theMedia.url)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.view.bounds
                playerView.layer.addSublayer(playerLayer)

                player.play()
            }

            self.title = self.media?.caption ?? "Image"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
