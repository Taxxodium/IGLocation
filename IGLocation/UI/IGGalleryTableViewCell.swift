//
//  IGGalleryTableViewCell.swift
//  IGLocation
//
//  Created by Jesus De Meyer on 15/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import UIKit
import InstagramKit
import SDWebImage

class IGGalleryTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaUsernameLabel: UILabel!
    @IBOutlet weak var mediaCommentsLabel: UILabel!

    var media: InstagramMedia? {
        didSet {
            self.updateCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let shadowView = UIView(frame: containerView.frame)
        self.containerView.insertSubview(shadowView, belowSubview: containerView)

        shadowView.layer.shadowColor = UIColor.red.cgColor
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.masksToBounds = false
        //shadowView.layer.bounds = containerView.bounds

        containerView.layer.cornerRadius = 10.0
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        //containerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell() {
        guard let theMedia = self.media else {
            return
        }

        self.mediaImageView.sd_setImage(with: theMedia.standardResolutionImageURL, completed: nil)
        self.mediaUsernameLabel.text = theMedia.user.username
        self.mediaCommentsLabel.text = theMedia.caption?.text
    }
}
