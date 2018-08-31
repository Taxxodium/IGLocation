//
//  ViewController.swift
//  IGLocation
//
//  Created by Jesus De Meyer on 14/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import UIKit
import InstagramKit

class ViewController: UIViewController {
    fileprivate var accessToken: String? {
        return InstagramEngine.shared().accessToken
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let _ = self.accessToken {

        }
        //InstagramEngine.shared().appClientID = "b2ce82469f344ad4a9ed871933156ec7"

        let url = InstagramEngine.shared().authorizationURL(for: .publicContent)

        //IGClient.shared.requestLoginPage { (html) in
        let webViewController = WebViewController(nibName: nil, bundle: nil)
        let navController = UINavigationController(rootViewController: webViewController)

        //webViewController.htmlContent = html
        webViewController.url = url

        self.present(navController, animated: true, completion: nil)
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

