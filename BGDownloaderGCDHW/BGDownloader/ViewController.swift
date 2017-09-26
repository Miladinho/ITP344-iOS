//
//  ViewController.swift
//  BGDownloader
//
//  Created by Administrator on 9/14/16.
//  Copyright © 2016 ITP. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	
	@IBOutlet weak var tableView: UITableView!
	
	let dataURLs : [String] = [
		"https://upload.wikimedia.org/wikipedia/commons/d/d8/NASA_Mars_Rover.jpg",
		"http://www.wired.com/wp-content/uploads/images_blogs/wiredscience/2012/08/Mars-in-95-Rover1.jpg",
		"http://news.brown.edu/files/article_images/MarsRover1.jpg",
		"http://www.nasa.gov/images/content/482643main_msl20100916-full.jpg",
		"https://upload.wikimedia.org/wikipedia/commons/f/fa/Martian_rover_Curiosity_using_ChemCam_Msl20111115_PIA14760_MSL_PIcture-3-br2.jpg",
		"http://mars.nasa.gov/msl/images/msl20110602_PIA14175.jpg",
		"http://i.kinja-img.com/gawker-media/image/upload/iftylroaoeej16deefkn.jpg",
		"http://www.nasa.gov/sites/default/files/thumbnails/image/journey_to_mars.jpeg",
		"http://i.space.com/images/i/000/021/072/original/mars-one-colony-2025.jpg?1375634917",
		"http://cdn.phys.org/newman/gfx/news/hires/2015/earthandmars.png"
	]
	
	var tableData : [UIImage] = []
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	@IBAction func downloadTouched(sender: AnyObject) {
        let downloadQueue = dispatch_queue_create("image download queue",DISPATCH_QUEUE_SERIAL)
    
        dispatch_async(downloadQueue,
            {
                var bt = UIBackgroundTaskInvalid
                bt = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
                    ()->Void in
                    UIApplication.sharedApplication().endBackgroundTask(bt)
                    bt = UIBackgroundTaskInvalid
                })
            
                for (idx,url) in self.dataURLs.enumerate()
                {
                    // check background time remaining
                    print(UIApplication.sharedApplication().backgroundTimeRemaining)
                    if (UIApplication.sharedApplication().backgroundTimeRemaining < 120.0) {
                        UIApplication.sharedApplication().endBackgroundTask(bt)
                        bt = UIBackgroundTaskInvalid
                    }
                    
                    // Download image
                    let image = UIImage(data: NSData(contentsOfURL: NSURL(string: url)!)!) // assuming url exists
                    
                    // add delay
                    //NSThread.sleepForTimeInterval(3)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        // Add image to tableView data source and update UI
                        self.tableView.beginUpdates()
                        self.tableData.append(image!)
                        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: idx,inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
                        self.tableView.endUpdates()
                    }
                }
                // cleanup background task when done
                UIApplication.sharedApplication().endBackgroundTask(bt)
                bt = UIBackgroundTaskInvalid
        })

        
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 50.0
	}
	

	let cellId = "cellId1"
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
		if(cell == nil){
			cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
		}
		
		cell?.imageView?.image = tableData[indexPath.row]
		cell?.textLabel?.text = dataURLs[indexPath.row]

		
		return cell!
	}
	
	
	


}

