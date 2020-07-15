//
//  StaticContentViewController.swift
//  SinglePageApp
//

import UIKit
import WebKit

class StaticContentViewController: UIViewController {
    
    let spacer: CGFloat = 16.0
    
    lazy var webview: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()
    
    lazy var fontIncreaseButton: UIButton = {
        let button = getStandardButton()
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(increaseFontSize), for: .touchUpInside)
        return button
    }()
    
    lazy var fontDecreaseButton: UIButton = {
        let button = getStandardButton()
        button.setTitle("-", for: .normal)
        button.addTarget(self, action: #selector(decreaseFontSize), for: .touchUpInside)
        return button
    }()
    
    lazy var fontButtonContainer: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [fontDecreaseButton, fontIncreaseButton])
        stackview.spacing = spacer
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    lazy var refreshButton: UIButton = {
        let button = getStandardButton()
        button.setTitle("Refresh", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    var request: URLRequest {
        guard let url = Bundle.main.url(forResource: "standard", withExtension: "html") else {
            fatalError("Fix it")
        }
        return URLRequest(url: url)
    }
    
    var fontSize = 26
    var cssRule: String {
        return """
        var s = document.createElement('style');
        s.textContent = 'body { font-size: \(fontSize)px; }';
        document.documentElement.appendChild(s);
        """
    }
    
    func getStandardButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.gray
        button.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.cyan
        
        layoutThePage()
    }
    
    func layoutThePage() {
        setupRefreshButton()
        setupFontButtons()
        setUpWebview()
    }
    
    func setUpWebview() {
        view.addSubview(webview)
        
        webview.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        webview.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -1 * spacer).isActive = true
        
        webview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacer).isActive = true
        webview.bottomAnchor.constraint(equalTo: fontButtonContainer.topAnchor, constant: -1 * spacer).isActive = true
        
        let script = WKUserScript(source: cssRule,
                                  injectionTime: .atDocumentStart,
                                  forMainFrameOnly: true)
        let configuration = webview.configuration
        configuration.userContentController.addUserScript(script)
        setupCommunication()
        
        setupPullToRefresh()
    }
    
    func setupPullToRefresh() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(something(_:)), for: .valueChanged)
        webview.scrollView.refreshControl = control
    }
    
    @objc func something(_ sender: UIRefreshControl) {
        print("*** soemthing happened")
    }
    func setupFontButtons() {
        view.addSubview(fontButtonContainer)
        
        fontButtonContainer.leadingAnchor.constraint(equalTo: refreshButton.leadingAnchor).isActive = true
        fontButtonContainer.trailingAnchor.constraint(equalTo: refreshButton.trailingAnchor).isActive = true
        
        fontButtonContainer.bottomAnchor.constraint(equalTo: refreshButton.topAnchor, constant: -1 * spacer).isActive = true
    }
    
    func setupRefreshButton() {
        view.addSubview(refreshButton)
        refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1 * spacer).isActive = true
        
        refreshButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        refreshButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -2 * spacer).isActive = true
    }
    
    @objc func buttonPressed() {
        webview.load(request)
    }
    
    @objc func increaseFontSize() {
        fontSize += 1
        print("*** increasing font size: \(fontSize)")
        webview.evaluateJavaScript(cssRule)
    }
    
    @objc func decreaseFontSize() {
        fontSize -= 1
        print("*** decreasing font size: \(fontSize)")
        webview.evaluateJavaScript(cssRule)
    }
    
    func setupCommunication() {
        let configuration = webview.configuration
        configuration.userContentController.add(self, name: "actionButton")
    }
}

// MARK: - WKNavigationDelegate
extension StaticContentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, let host = url.host {
                
                if host.hasSuffix("wsj.com") {
                    decisionHandler(.allow)
                } else {
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)
                }
                return
            }
        }
        decisionHandler(.allow)
    }
}

// MARK: - WKScriptMessageHandler
extension StaticContentViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        let handlerName = message.name
        print("Button was pressed: \(handlerName)")
        if let body = message.body as? String {
            print("With a message: \(body)")
        }
    }
    
    
}
