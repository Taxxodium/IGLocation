//
//  IGLoginViewController.swift
//  IGLocation
//
//  Created by Jesus De Meyer on 14/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import UIKit
import WebKit
import InstagramKit

class IGLoginViewController: UIViewController, WKNavigationDelegate {
    fileprivate lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()

        let view = WKWebView(frame: .zero, configuration: config)

        return view
    }()

    fileprivate lazy var progressView: UIProgressView = {
        return UIProgressView(progressViewStyle: .bar)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Login", comment: "")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleReload(_:)))

        setupWebView()
        setupProgressView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadLoginURL()
    }

    // MARK: -

    fileprivate func setupWebView() {
        self.webView.navigationDelegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.webView)

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webView]-0-|", options: [], metrics: nil, views: ["webView": self.webView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[webView]-|", options: [], metrics: nil, views: ["webView": self.webView]))

        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    fileprivate func setupProgressView() {
        self.progressView.progress = 0.0
        self.progressView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.progressView)

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[progressView]-0-|", options: [], metrics: nil, views: ["progressView": self.progressView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[progressView]", options: [], metrics: nil, views: ["progressView": self.progressView]))
    }

    // MARK: -

    fileprivate func loadLoginURL() {
        let url = InstagramEngine.shared().authorizationURL(for: [.publicContent])

        self.webView.load(URLRequest(url: url))
    }

    @objc func handleReload(_ sender: UIBarButtonItem) {
        loadLoginURL()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let path = keyPath else {
            return
        }

        switch path {
        case "estimatedProgress":
            self.progressView.progress = Float(self.webView.estimatedProgress)
            self.progressView.isHidden = self.progressView.progress >= 1.0
        default:
            break
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            var error: NSError?
            if InstagramEngine.shared().receivedValidAccessToken(from: url, error: &error) {
                if let _ = InstagramEngine.shared().accessToken {
                    //print("Token is: \(token)");
                    self.performSegue(withIdentifier: "showGallery", sender: nil)
                }
            }
        }
        
        decisionHandler(.allow)
    }

}
