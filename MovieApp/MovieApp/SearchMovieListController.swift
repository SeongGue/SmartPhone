//
//  SearchResultViewController.swift
//  MovieApp
//
//  Created by son on 2017. 6. 5..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//

import UIKit

class SearchMovieListController: UIViewController, XMLParserDelegate {
    var selectMovieCd = String()
    var selectMovieNm = String()
    var searchWord = String()
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var movieNm = NSMutableString()
    var openDt = NSMutableString()
    var movieCd = NSMutableString()
    //var selectMovieCd = String()
    var thumbnailParser = ThumbnailParser()
    //var director = NSMutableString()
    var searchKeyword = String()
    
    
    @IBOutlet weak var tbData: UITableView!
    //@IBOutlet weak var moviePoster: UIImageView!
   
    func beginParsing()
    {
        posts = []
        let addr = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.xml?key=430156241533f1d058c603178cc3ca0e&" + searchKeyword + searchWord
        let encodedParam = addr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        parser = XMLParser(contentsOf:(URL(string: encodedParam!))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
        //moviePoster.image = thumbnailParser.getThumbnail(movieName: searchWord)
        //moviePoster.image = thumbnailParser.getThumbnail()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "movie")
        {
            elements = NSMutableDictionary()
            elements = [:]
            movieNm = NSMutableString()
            movieNm = ""
            openDt = NSMutableString()
            openDt = ""
            movieCd = NSMutableString()
            movieCd = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String!)
    {
        if element.isEqual(to: "movieNm") {
            movieNm.append(string)
        } else if element.isEqual("openDt") {
            openDt.append(string)
        } else if element.isEqual("movieCd"){
            movieCd.append(string)
        } //else if element.isEqual("director"){
        //director.append(string)
        //}
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (elementName as NSString).isEqual(to: "movie") {
            if !movieNm.isEqual(nil) {
                elements.setObject(movieNm, forKey: "movieNm" as NSCopying)
            }
            if !openDt.isEqual(nil) {
                elements.setObject(openDt, forKey: "openDt" as NSCopying)
            }
            if !movieCd.isEqual(nil) {
                elements.setObject(movieCd, forKey: "movieCd" as NSCopying)
            }
            //if !director.isEqual(nil) {
            //elements.add(director)
            //}
            posts.add(elements)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        selectMovieCd = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "movieCd") as! NSString as String
        selectMovieNm = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "movieNm") as! NSString as String

        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "DetailSearch") as? SearchDetailDataViewController
            else{
                return
        }
        uvc.selectMovieCd = selectMovieCd
        uvc.selectMovieNm = selectMovieNm
        
        self.present(uvc, animated: true)
    
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if(cell.isEqual(NSNull)) {
            cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)?[0] as! UITableViewCell;
        }
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "movieNm") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "openDt") as! NSString as String
        
        return cell as UITableViewCell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
