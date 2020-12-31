//
//  UIImageView+DownloadingImage.swift
//  storesearch
//
//  Created by 한석희 on 12/31/20.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImage(url: URL) -> URLSessionDownloadTask {
        
        let session = URLSession.shared // shared singleton session object
        let downloadTask = session.downloadTask(with: url, completionHandler: {
            [weak self] url, _, error in
            if error == nil,
               let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                //
                DispatchQueue.main.async {
                    if let weakSelf = self{
                        weakSelf.image = image
                        }
                    }
                }
            //
            }
        )
        //MARK:- Finished Making Download Task
        downloadTask.resume() // STARTS ON BACK THREAD !!
        return downloadTask // RETURNS TO THE CALLER - REF. TO THIS DOWNLOAD TASK
    }
    //
    
}
