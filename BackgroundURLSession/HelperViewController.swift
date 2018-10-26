//
//  HelperViewController.swift
//  BackgroundURLSession
//
// 
//

import UIKit

class HelperViewController: UIViewController {

    enum Constant: String {
        case sessionID = "CustomBackgroundSession"
    }
    
    var onProgress: ((Double) -> ())?
    var onCompleted: ((URL) -> ())?
    
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: Constant.sessionID.rawValue)
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
    }()
    func startDownload() {
        
    let arrayUrl = ["https://images.unsplash.com/photo-1534004017545-37dfacd65bc6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=d39a8fb06fcb77f1b75597e981f7a707&auto=format&fit=crop&w=668&q=80","https://images.unsplash.com/photo-1534083264897-aeabfc7daf8a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=d40d4da633c570324291ec2e6e5bd4f5&auto=format&fit=crop&w=1500&q=80","https://images.unsplash.com/photo-1534018309045-bbad1f378686?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=4830498ee6471812aa585a76f1aac59e&auto=format&fit=crop&w=660&q=80","https://images.unsplash.com/photo-1534003729292-1df8d1798786?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=d4c08b0df1654d430220e50de09e311e&auto=format&fit=crop&w=668&q=80","https://images.unsplash.com/photo-1534054477014-696beafcf028?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ed2bbe134026e522de3dfac341a20ea1&auto=format&fit=crop&w=664&q=80","https://images.unsplash.com/photo-1534054477014-696beafcf028?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ed2bbe134026e522de3dfac341a20ea1&auto=format&fit=crop&w=664&q=80","https://images.unsplash.com/photo-1534054477014-696beafcf028?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ed2bbe134026e522de3dfac341a20ea1&auto=format&fit=crop&w=664&q=80","https://images.unsplash.com/photo-1534054477014-696beafcf028?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ed2bbe134026e522de3dfac341a20ea1&auto=format&fit=crop&w=664&q=80","https://images.unsplash.com/photo-1534054477014-696beafcf028?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ed2bbe134026e522de3dfac341a20ea1&auto=format&fit=crop&w=664&q=80"]
        for i in arrayUrl{
           if let url = URL(string: i) {
               let bgTask = bgSession.downloadTask(with: url)
               print(bgSession.configuration.identifier ?? "Error")
                bgTask.resume()
        }
      }
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
extension HelperViewController : URLSessionDelegate{
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompletionHandler
                else {
                    return
            }
            appDelegate.bgSessionCompletionHandler = nil
            completionHandler()
        }
    }
}
extension HelperViewController : URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        DispatchQueue.main.async {
            self.onCompleted?(location)
        }
    }
  
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else {
            return
        }

        let progress = Double(Double(totalBytesWritten)/Double(totalBytesExpectedToWrite))
        print("Download progress: \(progress)")
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
