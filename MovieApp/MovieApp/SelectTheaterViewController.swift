//
//  SelectTheaterViewController.swift
//  MovieApp
//
//  Created by son on 2017. 6. 9..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//

import UIKit

class SelectTheaterViewController: UIViewController {
    @IBOutlet weak var tbData: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        let selectTheater = indexPath.row
        
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
            else{
                return
        }
        uvc.selectTheater = selectTheater
        
        self.present(uvc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if(cell.isEqual(NSNull)) {
            cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)?[0] as! UITableViewCell;
        }
        
        if(indexPath.row == 0){
            cell.textLabel?.text = "롯데시네마"
        } else if(indexPath.row == 1){
            cell.textLabel?.text = "CGV"
        }else if(indexPath.row == 2){
            cell.textLabel?.text = "메가박스"
        }
        return cell as UITableViewCell
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
