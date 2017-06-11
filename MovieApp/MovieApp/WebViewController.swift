//
//  WebViewController.swift
//  MovieApp
//
//  Created by son on 2017. 6. 9..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var wv: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var selectTheater = Int()
    
    @IBAction func dismiss(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func selectTheaterURL() -> String
    {
        var theaterURL = String()
        if selectTheater == 0{
            theaterURL = "http://www.lottecinema.co.kr/LCMW/Contents/Ticketing/ticketing.aspx#none"
        }
        else if selectTheater == 1{
            theaterURL = "http://m.cgv.co.kr"
        }
        else if selectTheater == 2{
            theaterURL = "http://m.megabox.co.kr"
        }
        return theaterURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.wv.delegate = self
        let url = URL(string: selectTheaterURL())
        let req = URLRequest(url: url!)
        self.wv.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = (request.url?.absoluteString)! as NSString
        
        if(url.substring(to: 4) == "http"){
            return true
        }
        else{
            return false
        }
        
        /*
         let scheme = request.url!
         NSLog(scheme.absoluteString)
         
         return true
         */
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.spinner.stopAnimating()
        
        let alert = UIAlertController(title: "오류", message: "상세페이지를 읽어오지 못했습니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel){
            (_) in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: false, completion: nil)
    }
    
}
