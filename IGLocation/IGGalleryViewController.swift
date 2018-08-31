//
//  ViewController.swift
//  IGLocation
//
//  Created by Jesus De Meyer on 14/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import UIKit
import InstagramKit

class IGGalleryViewController: UITableViewController {
    fileprivate var mediaItems = [IGMedia]()

    fileprivate var nextMaxId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Gallery", comment: "")

        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(handleReload(_:)), for: .valueChanged)

        updateGallery()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: -

    fileprivate func updateGallery() {
        if let next = self.nextMaxId, next.isEmpty {
            return
        }

        InstagramEngine.shared().getSelfRecentMedia(withCount: 10, maxId: nextMaxId, success: { (mediaList, paginationInfo) in
            self.nextMaxId = paginationInfo.nextMaxId

            self.tableView.beginUpdates()

            for media in mediaList {
                let newMedia = IGMedia(media: media)
                self.mediaItems.append(newMedia)
                self.tableView.insertRows(at: [IndexPath(row: self.mediaItems.count-1, section: 0)], with: .fade)
            }
            self.tableView.endUpdates()

        }) { (error, code, userInfo) in
            let alertController = UIAlertController(title: NSLocalizedString("Unable to load media!", comment: ""), message: "Something went wrong while retrieving the media from Instagram: \(error.localizedDescription)", preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in

            }))

            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: -

    @objc func handleReload(_ sender: UIRefreshControl) {
        mediaItems.removeAll()
        nextMaxId = nil
        updateGallery()
    }

    // MARK: -

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryItemCell") as! IGGalleryTableViewCell

        cell.media = self.mediaItems[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        self.performSegue(withIdentifier: "showDetail", sender: self.mediaItems[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    // MARK: -

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadMediaWhenReachingBottom(scrollView)
    }

    func loadMediaWhenReachingBottom(_ scrollView: UIScrollView) {
        let maxHeight = scrollView.contentSize.height
        let visibleFrameBottom = scrollView.contentOffset.y+scrollView.frame.height

        if visibleFrameBottom >= maxHeight {
            updateGallery()
        }
    }

    // MARK: -

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else {
            return
        }

        switch id {
        case "showDetail":
            let controller = segue.destination as! IGGalleryDetailViewController

            controller.media = sender as? IGMedia
            break
        default:
            break
        }
    }

}

