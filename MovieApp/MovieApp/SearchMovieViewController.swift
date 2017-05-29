//
//  SearchMovieViewController.swift
//  MovieApp
//
//  Created by son on 2017. 5. 28..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//

import UIKit

class SearchMovieViewController: UIViewController, XMLParserDelegate {
    var searchWord = String()
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableArray()
    var element = NSString()
    var movieNm = NSMutableString()
    var openDt = NSMutableString()
    var genreAlt = NSMutableString()
    var thumbnailParser = ThumbnailParser()
    //var director = NSMutableString()
    
    @IBOutlet weak var tbData: UITableView!
    @IBOutlet weak var moviePoster: UIImageView!
    
    func beginParsing()
    {
        posts = []
        let addr = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.xml?key=430156241533f1d058c603178cc3ca0e&movieNm=" + searchWord
        let encodedParam = addr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        parser = XMLParser(contentsOf:(URL(string: encodedParam!))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
        moviePoster.image = thumbnailParser.getThumbnail(movieName: searchWord)
        //moviePoster.image = thumbnailParser.getThumbnail()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "movie")
        {
            elements = NSMutableArray()
            elements = []
            movieNm = NSMutableString()
            movieNm = ""
            openDt = NSMutableString()
            openDt = ""
            genreAlt = NSMutableString()
            genreAlt = ""
            //director = NSMutableString()
            //director = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String!)
    {
        if element.isEqual(to: "movieNm") {
            movieNm.append(string)
        } else if element.isEqual("openDt") {
            openDt.append(string)
        } else if element.isEqual("genreAlt"){
            genreAlt.append(string)
        } //else if element.isEqual("director"){
        //director.append(string)
        //}
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (elementName as NSString).isEqual(to: "movie") {
            if !movieNm.isEqual(nil) {
                elements.add(movieNm)
            }
            if !openDt.isEqual(nil) {
                elements.add(openDt)
            }
            if !genreAlt.isEqual(nil) {
                elements.add(genreAlt)
            }
            //if !director.isEqual(nil) {
            //elements.add(director)
            //}
            posts.add(elements)
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return elements.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if(cell.isEqual(NSNull)) {
            cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)?[0] as! UITableViewCell;
        }
        if(indexPath.row == 0){
            cell.textLabel?.text = "타이틀"
        }
        
        if(indexPath.row == 1){
            cell.textLabel?.text = "개봉일"
        }
        
        if(indexPath.row == 2){
            cell.textLabel?.text = "장르"
        }
        
        cell.detailTextLabel?.text = elements.object(at: indexPath.row) as! String
        
        return cell as UITableViewCell
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search Word"
        {
            moviePoster.image = thumbnailParser.getThumbnail(movieName: sender as! String)
        }
    }
 */
 
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

