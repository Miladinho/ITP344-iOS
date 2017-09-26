//
//  FriendsVC.swift
//  FaceBook
//
//  Created by Administrator on 10/5/16.
//  Copyright © 2016 ITP344. All rights reserved.
//

import UIKit
import FBSDKCoreKit



class FriendsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var friendsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

		if(FBSDKAccessToken.current().hasGranted("user_friends")){
			
			// perform graph request
            let graphRequest = FBSDKGraphRequest(graphPath: "/me/taggable_friends?limit=10000" , parameters: nil)
            graphRequest?.start(completionHandler: 	{
                (connection, result, error) -> Void in
                print(connection)
                if (error == nil){
                    //print(result)
                    // cast result data as a dictrionary
                    let resultDict = result as! [String:Any]
                    // get the "data" value from the dictionary and cast as an array of dictionaries
                    let friends = resultDict["data"] as! [[String:Any]]
                    // iterate through each item
                    for friend in friends {
                        let name = friend["name"]
                        // ***add to your own array***
                        self.friendsArray.append(name as! String)
                        
                    }
                    //print(self.friendsArray.count)

                    self.tableView.reloadData()
                }
            })


			
		}else{
			print("user_freinds access not granted")
			
		}
		
		
	
	}
	@IBAction func closeButtonTouched(_ sender: AnyObject) {
		
		self.dismiss(animated: true, completion: nil)
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        cell.textLabel?.text = self.friendsArray[indexPath.row]
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
