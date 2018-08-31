//
//  IGGalleryTableViewCell.swift
//  IGLocation
//
//  Created by Jesus De Meyer on 15/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class IGGalleryTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaUsernameLabel: UILabel!
    @IBOutlet weak var mediaUserAvatar: UIImageView!
    @IBOutlet weak var mediaCommentsLabel: UILabel!

    @IBOutlet weak var mediaLikesLabel: UILabel!
    fileprivate var currentVideoView: UIView?
    fileprivate var currentVideoPlayer: AVPlayer?

    var media: IGMedia? {
        didSet {
            self.updateCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10.0
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

        mediaImageView.alpha = 0

        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
            self.currentVideoPlayer?.seek(to: kCMTimeZero)
            self.currentVideoPlayer?.play()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateCell() {
        self.mediaImageView.image = nil

        if let doomedView = currentVideoView {
            doomedView.removeFromSuperview()
        }

        guard let theMedia = self.media else {
            return
        }

        if theMedia.type == .image {
            self.mediaImageView.sd_setImage(with: theMedia.url) { (image, err, cacheType, url) in
                UIView.animate(withDuration: 0.25) {
                    self.mediaImageView.alpha = 1.0
                }
            }
        } else {
            let newVideoView = UIView(frame: .zero)
            newVideoView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(newVideoView)

            containerView.addConstraint(NSLayoutConstraint(item: newVideoView, attribute: .left, relatedBy: .equal, toItem: mediaImageView, attribute: .left, multiplier: 1.0, constant: 0))
            containerView.addConstraint(NSLayoutConstraint(item: newVideoView, attribute: .right, relatedBy: .equal, toItem: mediaImageView, attribute: .right, multiplier: 1.0, constant: 0))
            containerView.addConstraint(NSLayoutConstraint(item: newVideoView, attribute: .top, relatedBy: .equal, toItem: mediaImageView, attribute: .top, multiplier: 1.0, constant: 0))
            containerView.addConstraint(NSLayoutConstraint(item: newVideoView, attribute: .bottom, relatedBy: .equal, toItem: mediaImageView, attribute: .bottom, multiplier: 1.0, constant: 0))

            let player = AVPlayer(url: theMedia.url)
            player.isMuted = true
            currentVideoPlayer = player

            let videoLayer = AVPlayerLayer(player: player)
            videoLayer.frame = self.mediaImageView.bounds
            newVideoView.layer.addSublayer(videoLayer)

            currentVideoView = newVideoView

            player.play()
        }

        self.mediaUsernameLabel.text = theMedia.username
        self.mediaCommentsLabel.text = theMedia.caption

        if let avatarURL = theMedia.userAvatarURL {
            self.mediaUserAvatar.isHidden = false
            self.mediaUserAvatar.sd_setImage(with: avatarURL, completed: nil)
        } else {
            self.mediaUserAvatar.isHidden = true
        }

        let likes = theMedia.numberOfLikes
        if likes == 1 {
            self.mediaLikesLabel.text = "\(likes) like"
        } else {
            self.mediaLikesLabel.text = "\(likes) likes"
        }
    }
}
