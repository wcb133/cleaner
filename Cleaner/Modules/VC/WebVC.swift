//
//  HCBaseWebViewController.swift
//  HippoCharge
//
//  Created by jemi on 2020/6/4.
//  Copyright © 2020 leon. All rights reserved.
//

import QMUIKit
import WebKit

class WebVC: BaseVC {
    
    var titleStr = ""
    var url = ""
    var webView = WKWebView()
    // 进度条
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.orange
        progress.trackTintColor = .clear
        return progress
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.progressView.frame = CGRect(x:0,y:0,width:cScreenWidth,height:2)
        self.progressView.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView?.title = titleStr
        webView = WKWebView()
        view.addSubview(webView)
        webView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        webView.navigationDelegate = self
        let mapwayURL = URL(string: url)!
        let mapwayRequest = URLRequest(url: mapwayURL)
        webView.load(mapwayRequest)
        
        view.addSubview(self.progressView)
        progressView.snp.makeConstraints { (m) in
            m.leading.trailing.top.equalToSuperview()
            m.height.equalTo(2)
        }
    }
}

extension WebVC:WKNavigationDelegate{
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
//        self.navigationItem.title = "加载中..."
        /// 获取网页的progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
//        self.title = self.webView.title
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
            self.progressView.isHidden = true
        }
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        QMUITips.show(withText: "加载失败")
        
    }
    
}
