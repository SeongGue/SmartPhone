//
//  SearchMovieViewController.swift
//  MovieApp
//
//  Created by son on 2017. 5. 28..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//

import UIKit

class SearchDetailDataViewController: UIViewController, XMLParserDelegate {
    var searchWord = String()
    var selectMovieCd = String()
    var selectMovieNm = String()
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableArray()
    var element = NSString()
    var movieNm = NSMutableString()
    var openDt = NSMutableString()
    var genres = NSMutableArray()
    var directors = NSMutableArray()
    var actors = NSMutableArray()
    var thumbnailParser = ThumbnailParser()
    var isDirector = Bool()
    var isActor = Bool()
    
    @IBOutlet weak var tbData: UITableView!
    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBAction func dismiss(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func beginParsing()
    {
        posts = []
        let addr = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.xml?key=430156241533f1d058c603178cc3ca0e&movieCd=" + selectMovieCd
        let encodedParam = addr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        parser = XMLParser(contentsOf:(URL(string: encodedParam!))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
        moviePoster.image = thumbnailParser.getThumbnail(movieName: selectMovieNm)
        //moviePoster.image = thumbnailParser.getThumbnail()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "movieInfo")
        {
            elements = NSMutableArray()
            elements = []
            movieNm = NSMutableString()
            movieNm = ""
            openDt = NSMutableString()
            openDt = ""
            genres = NSMutableArray()
            genres = []
            directors = NSMutableArray()
            directors = []
            actors = NSMutableArray()
            actors = []
            isDirector = true
            isActor = true
        }
        
        if (elementName as NSString).isEqual(to: "director"){
            isDirector = true
            isActor = false
        } else if (elementName as NSString).isEqual(to: "actor"){
            isDirector = false
            isActor = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String!)
    {
        if element.isEqual(to: "movieNm") {
            movieNm.append(string)
        } else if element.isEqual("openDt") {
            openDt.append(string)
        } else if element.isEqual("genreNm"){
            genres.add(string)
        } else if (element.isEqual("peopleNm") && isDirector){
            directors.add(string)
        } else if (element.isEqual("peopleNm") && isActor){
            actors.add(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (elementName as NSString).isEqual(to: "movieInfo") {
            if !movieNm.isEqual(nil) {
                elements.add(movieNm)
            }
            if !openDt.isEqual(nil) {
                elements.add(openDt)
            }
            if !genres.isEqual(nil) {
                elements.add(genres)
            }
            if !directors.isEqual(nil) {
                elements.add(directors)
            }
            if !actors.isEqual(nil) {
                elements.add(actors)
            }
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
            cell.detailTextLabel?.text = elements.object(at: indexPath.row) as! String
        }
        
        if(indexPath.row == 1){
            cell.textLabel?.text = "개봉일"
            cell.detailTextLabel?.text = elements.object(at: indexPath.row) as! String
        }
        
        if(indexPath.row == 2){
            cell.textLabel?.text = "장르"
            var genresList = ""
            for i in 0..<(elements.object(at: indexPath.row) as AnyObject).count
            {
                if(i < (elements.object(at: indexPath.row) as AnyObject).count - 1)
                {
                    genresList += (elements.object(at: indexPath.row) as AnyObject).object(at: i) as! String + ", "
                }
                else
                {
                    genresList += (elements.object(at: indexPath.row) as AnyObject).object(at: i) as! String
                }
            }
            cell.detailTextLabel?.text = genresList
        }
        if(indexPath.row == 3){
            cell.textLabel?.text = "감독"
            var directorList = ""
            for i in 0..<(elements.object(at: indexPath.row) as AnyObject).count
            {
                if(i < (elements.object(at: indexPath.row) as AnyObject).count - 1)
                {
                    directorList += (elements.object(at: indexPath.row) as AnyObject).object(at: i) as! String + ", "
                }
                else
                {
                    directorList += (elements.object(at: indexPath.row) as AnyObject).object(at: i) as! String
                }
            }
            cell.detailTextLabel?.text = directorList
        }
        
        if(indexPath.row == 4){
            cell.textLabel?.text = "배우"
            var actorList = ""
            for i in 0..<(elements.object(at: indexPath.row) as AnyObject).count
            {
                if(i < (elements.object(at: indexPath.row) as AnyObject).count - 1)
                {
                    actorList += (elements.object(at: indexPath.row) as AnyObject).object(at: i) as! String + ", "
                }
                else
                {
                    actorList += (elements.object(at: indexPath.row) as AnyObject).object(at: i) as! String
                }
            }
            cell.detailTextLabel?.text = actorList
        }
        
        
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

