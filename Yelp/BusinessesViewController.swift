//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, UIScrollViewDelegate {

    let DefaultSearchString = ""
    var currentOffset = 0
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    var filteredBusiness: [Business]!
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        if let navController = navigationController {
            navController.navigationBar.barTintColor = UIColor(red:0.78, green:0.09, blue:0.07, alpha:0.94)
            navController.navigationBar.tintColor = UIColor.whiteColor()
            
        }
        loadData(DefaultSearchString,OffSet: 0)
        

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    func loadData(searchString: String, OffSet: Int){
        
        Business.searchWithTerm(searchString, offset: 0+OffSet, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.isMoreDataLoading = false
            self.businesses = businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
              //  print(business.address!)
            }
        })

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        loadData(searchText,OffSet: 0)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                currentOffset += 20
                isMoreDataLoading = true
                loadData(DefaultSearchString,OffSet: currentOffset)
                //self.isMoreDataLoading = false
            }
        }
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if businesses != nil {
            print("\(businesses.count)")
            return businesses.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        
        return cell
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
