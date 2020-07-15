//
//  URLContentViewController.swift
//  SinglePageApp
//

import UIKit
import WebKit

class URLContentViewController: UIViewController {
    
    lazy var webview: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    var request: URLRequest {
        guard let url = URL(string: "https://www.yahoo.com") else {
            fatalError("Fix it")
        }
        return URLRequest(url: url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(webview)
        webview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        webview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        webview.load(request)
    }

}
