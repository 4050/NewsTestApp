//
//  WebViewController.swift
//  DBOSoftTestApp
//
//  Created by Stanislav on 14.03.2021.
//


import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    private var webView: WKWebView!
    
    public var stringURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        renderURL(url: stringURL!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func renderURL(url: String) {
        self.webView.loadHTMLString(url, baseURL: nil)
    }
    
    
}
