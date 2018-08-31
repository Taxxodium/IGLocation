//
//  WebViewController.swift
//  IGLocation
//
//  Created by Jesus De Meyer on 14/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import UIKit
import WebKit
import InstagramKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var htmlContent: String = ""
    var url: URL?

    fileprivate lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()

        let view = WKWebView(frame: .zero, configuration: config)

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.webView)

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webView]-0-|", options: [], metrics: nil, views: ["webView": self.webView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[webView]-0-|", options: [], metrics: nil, views: ["webView": self.webView]))

        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        if let theURL = url {
            self.webView.load(URLRequest(url: theURL))
        }

        //self.webView.loadHTMLString(self.htmlContent, baseURL: nil)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone(_:)))
    }

    @objc func handleDone(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let path = keyPath else {
            return
        }

        switch path {
        case "estimatedProgress":
            print("\(self.webView.estimatedProgress)")
        default:
            break
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            var error: NSError?
            if InstagramEngine.shared().receivedValidAccessToken(from: url, error: &error) {
                print("Token is: \(InstagramEngine.shared().accessToken ?? "")")
            }
        }

        decisionHandler(.allow)
    }

}
