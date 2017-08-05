//
//  ViewController.swift
//  AHDownloadTool
//
//  Created by Andy Tong on 6/22/17.
//  Copyright © 2017 Andy Tong. All rights reserved.
//

import UIKit
import AHDownloadTool


let testURL1 = "https://firebasestorage.googleapis.com/v0/b/savori-6387d.appspot.com/o/jing.dmg?alt=media&token=974da0f1-bed6-4a0c-8d01-ef63f29ae303"
let testURL2 = "http://www.yellowmug.com/download/SnapNDrag.dmg"
let testURL3 = "http://www.yellowmug.com/download/EasyBatchPhoto.dmg"
let testURL4 = "https://firebasestorage.googleapis.com/v0/b/savori-6387d.appspot.com/o/All_Inuyasha_Openings.mp3?alt=media&token=8e78127b-4a0b-4f4d-b8cc-a7256a10457c"

class ViewController: UIViewController {
    var test4ProgressA: Double = 0.0
    var test3ProgressA:Double = 0.0
    // progressA is previous pregress, progressB is current progress
    let progressFilter: (_ testName: String, _ progressA: inout Double, _ progressB: Double) -> Void = { (name,progressA,progressB) in
        let percentA = Int(progressA * 100)
        let percentB = Int(progressB * 100)
        let preTens = percentA % 10 == 0
        let currentTens = percentB % 10 == 0
        if preTens != currentTens {
            progressA = progressB
            print("\(name): \(percentB)")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Test AHFileSizeProbe
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AHFileSizeProbe.probe(urlStr: testURL4) { (size) in
            print("single size:\(size)")
        }
        
        let fileUrls = [testURL1,testURL2,testURL3,testURL4]
        
        for urlStr in fileUrls {
            AHFileSizeProbe.probe(urlStr: urlStr) { (size) in
                print("single size:\(size)")
            }
        }
        
        AHFileSizeProbe.probeBatch(urlStrs: [testURL1,testURL2,testURL3,testURL4]) { (sizes) in
            for value in sizes.values {
                print("batch size:\(value)")
            }
        }
        
    }
    
    
    // Test AHDataTaskManager
    @IBAction func startTapped(_ sender: UIButton) {
        AHDataTaskManager.donwload(fileName: "testURL4.mp3", url: testURL4, fileSizeCallback: { (fileSize) in
            print("testURL4 size:\(fileSize)")
        }, progressCallback: { (progress) in
            self.progressFilter("testURL4", &self.test4ProgressA, progress)
        }, successCallback: { (filePath) in
            print("testURL4 ok, path:\(filePath)")
            AHFileTool.remove(filePath: filePath)
        }) { (error) in
            print("testURL4 failed error:\(error)")
        }
        
        
        AHDataTaskManager.donwload(url: testURL3, fileSizeCallback: { (fileSize) in
            print("testURL3 size:\(fileSize)")
        }, progressCallback: { (progress) in
            self.progressFilter("testURL3", &self.test3ProgressA, progress)
        }, successCallback: { (filePath) in
            print("testURL3 ok, path:\(filePath)")
            AHFileTool.remove(filePath: filePath)
        }) { (error) in
            print("testURL3 failed error:\(error)")
        }
        
        
    }
    @IBAction func pauseTapped(_ sender: UIButton) {
        AHDataTaskManager.pauseAll()
    }
    @IBAction func resumeTapped(_ sender: UIButton) {
        AHDataTaskManager.resumeAll()
    }
    @IBAction func cancelTapped(_ sender: UIButton) {
        AHDataTaskManager.cancelAll()
    }

}
extension ViewController {
    
}
