//
//  AHDataTaskManager.swift
//  AHDownloadTool
//
//  Created by Andy Tong on 6/22/17.
//  Copyright © 2017 Andy Tong. All rights reserved.
//

import UIKit

public class AHDataTaskManager: NSObject {
    public static var timeout: TimeInterval = 8.0
    fileprivate static var dataTaskDict = [String: AHDataTask]()
}

public extension AHDataTaskManager {
    public static func donwload(fileName: String?=nil, url: String, fileSizeCallback: ((_ fileSize: UInt64) -> Void)?, progressCallback: ((_ progress: Double) -> Void)?, successCallback: ((_ filePath: String) -> Void)?, failureCallback: ((_ error: Error?) -> Void)?) {
        
        self.donwload(fileName: fileName, tempDir: nil, cachePath: nil, url: url, fileSizeCallback: fileSizeCallback, progressCallback: progressCallback, successCallback: successCallback, failureCallback: failureCallback)
        
    }
    public static func donwload(fileName: String?, tempDir: String?, cachePath: String?,url: String, fileSizeCallback: ((_ fileSize: UInt64) -> Void)?, progressCallback: ((_ progress: Double) -> Void)?, successCallback: ((_ filePath: String) -> Void)?, failureCallback: ((_ error: Error?) -> Void)?) {
        
        var dataTask = dataTaskDict[url]
    
        if dataTask == nil {
            dataTask = AHDataTask()
            dataTask?.timeout = timeout
            dataTask?.fileName = fileName
            dataTask?.tempDir = tempDir
            dataTask?.cacheDir = cachePath
            dataTaskDict[url] = dataTask
            
            
            dataTask?.donwload(url: url, fileSizeCallback: fileSizeCallback, progressCallback: progressCallback, successCallback: { (path) in
                self.dataTaskDict.removeValue(forKey: url)
                successCallback?(path)
            }, failureCallback: { (error) in
                self.dataTaskDict.removeValue(forKey: url)
                failureCallback?(error)
            })

        }else{
            print("download task repeated!")
        }

    }
    
    public static func resume(url: String) {
        if let dataTask = dataTaskDict[url] {
            dataTask.resume()
        }
    }
    
    public static func resumeAll() {
        for url in dataTaskDict.keys {
            resume(url: url)
        }
    }
    
    public static func pause(url: String) {
        if let dataTask = dataTaskDict[url] {
            dataTask.pause()
        }
    }
    
    public static func pauseAll() {
        for url in dataTaskDict.keys {
            pause(url: url)
        }
    }
    
    /// When cancel, the temporary file will be deleted as well.
    public static func cancel(url: String) {
        if let dataTask = dataTaskDict[url] {
            dataTask.cancel()
            dataTaskDict.removeValue(forKey: url)
        }
    }
    
    /// When cancel, the temporary file will be deleted as well.
    public static func cancelAll() {
        for url in dataTaskDict.keys {
            cancel(url: url)
        }
    }
    
}







