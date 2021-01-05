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
            //
            [weak self] url, _, error in // 하드디스크 유알엘 에 대하여
            if error == nil,
               let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) { // UIImage까지 만든 후에 !!
                //
                DispatchQueue.main.async {
                    if let weakSelf = self{
                        weakSelf.image = image // 다시 UIImageView의 이미지 속성에 세터-셋 해주지 모야 !! // 통신이 성공 못하면 얄짤없고 ...
                        }
                    }
                }
            }
        )
        
        //MARK:- Finished Making Download Task
        downloadTask.resume() // STARTS ON BACK THREAD !!
        return downloadTask // RETURNS TO THE CALLER - REF. TO THIS DOWNLOAD TASK -> 캔슬 할 수 있게 해줌
    }
    //
}
