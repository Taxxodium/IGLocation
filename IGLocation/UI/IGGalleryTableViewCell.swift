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
    fileprivate var currentVideoView: IGVideoPlayerView?
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
            self.mediaImageView.sd_setImage(with: theMedia.url, completed: nil)
        } else {
            let newVideoView = IGVideoPlayerView(frame: .zero)

            newVideoView.url = theMedia.url

            newVideoView.overlay(on: mediaImageView)
            newVideoView.player.isMuted = true

            currentVideoView = newVideoView
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
