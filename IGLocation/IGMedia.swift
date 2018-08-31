//
//  IGMedia.swift
//  IGLocation
//
//  Created by Jesus De Meyer on 30/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import UIKit
import CoreLocation
import InstagramKit

enum IGMediaType: Int {
    case image
    case video

    init?(rawString: String) {
        switch rawString.lowercased() {
        case "image":
            self = .image
        case "video":
            self = .video
        default:
            return nil
        }
    }

    func stringValue() -> String {
        switch self {
        case .image:
            return "image"
        case .video:
            return "video"
        }
    }
}
class IGMedia: NSObject {
    var id: String?
    var url: URL
    var username: String?
    var userAvatarURL: URL?
    var caption: String?
    var comments = [String]()
    var numberOfLikes: Int = 0
    var location: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    var type: IGMediaType = .image

    init(media: InstagramMedia) {
        self.username = media.user.username
        self.userAvatarURL = media.user.profilePictureURL
        self.caption = media.caption?.text
        if let comments = media.comments {
            for comment in comments {
                let commentString = "\(comment.user.username): \(comment.text)"
                self.comments.append(commentString)
            }
        }
        self.location = media.location
        self.numberOfLikes = media.likesCount
        if media.isVideo {
            self.type = .video
            if let videoURL = media.standardResolutionVideoURL {
                self.url = videoURL
            } else {
                self.url = media.standardResolutionImageURL
            }
        } else {
            self.type = .image
            self.url = media.standardResolutionImageURL
        }

        super.init()
    }
}
