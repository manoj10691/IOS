//
//  HomeViewController.swift
//  Clean Login
//
//

import Foundation
import UIKit
import WebKit

class VPdfViewController: UIViewController {
    
    @IBOutlet weak var webViewP: WKWebView!
    @IBOutlet weak var nameText: UITextView!
    var vPName: String = ""
    var vPUrl: String = ""
    
    override func viewDidLoad() {
           super.viewDidLoad()
            createWebView()
       }
    
    private func createWebView(){
        //let webView = WKWebView(frame: frame)
        //self.webViewP.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.nameText.text = self.vPName
        if let resourceUrl = URL(string: self.vPUrl) {
            let request = URLRequest(url: resourceUrl)
            self.webViewP.load(request)
            
        }
    }
    
    @IBAction func actClosePdf(_ sender: UIButton) {
       
        navigationController?.popViewController(animated: true)
        
    }
    
}
