//
//  PeekPagedScrollViewController.swift
//  MovieApp
//
//  Created by son on 2017. 5. 19..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//
//import Foundation
import UIKit

class ThumbnailParser: UIViewController, XMLParserDelegate {
    var parser = XMLParser()
    var element = NSString()
    var imageurl = NSMutableString()
    var thumbnailURL = String()
    
    let daumQuery = "https://apis.daum.net/contents/movie?apikey=ec4371baf735ac91f514b3dca6f74ff6&q="
    
    func getThumbnail(movieName: String) -> UIImage
    {
        thumbnailURL = ""
        let addr = daumQuery + movieName
        let encodedParam = addr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        parser = XMLParser(contentsOf:(URL(string: encodedParam!))!)!
        parser.delegate = self
        parser.parse()
        
        let url = URL(string: thumbnailURL)
        
        if(url != nil){
            let data = try? Data(contentsOf: url!)
            return UIImage(data: data!)!
        }
        else{
            return UIImage(named: "no_img.png")!
        }
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        
        if(elementName as NSString).isEqual(to: "thumbnail")
        { 
             imageurl = NSMutableString()
             imageurl = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual("content") {
            if imageurl.isEqual(""){
                imageurl.append(string)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (elementName as NSString).isEqual(to: "thumbnail") {
            
            if thumbnailURL.isEqual("") {
                thumbnailURL.append(imageurl as String)
            }
        }
    }
}
