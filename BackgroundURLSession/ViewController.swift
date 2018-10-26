//
//  ViewController.swift
//  BackgroundURLSession
//
// 

import UIKit


class ViewController: UIViewController {
    
 
    private let controller = HelperViewController()
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var dlLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        
        controller.onProgress = { (progress) in
            self.progressView.progress = Float(progress)
            
        }
        
        controller.onCompleted = { (location) in
          
            print("Download finished: \(location.absoluteString)")
            self.dlLocationLabel.text = location.absoluteString
            
        }
    }
    

    
    @IBAction func downloadAction(_ sender: Any) {
       controller.startDownload()
        
    }
   
}


