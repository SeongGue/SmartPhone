//
//  PeekPagedScrollViewController.swift
//  MovieApp
//
//  Created by son on 2017. 5. 19..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//

import UIKit

class PeekPagedScrollViewController: UIViewController, UIScrollViewDelegate, XMLParserDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    var thumbnailParser = ThumbnailParser()
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var date = NSMutableString()
    var imageurl = NSMutableString()
    
    func beginParsing()
    {
        posts = []
        /*
        parser = XMLParser(contentsOf:(URL(string:"https://apis.daum.net/contents/movie?apikey=ec4371baf735ac91f514b3dca6f74ff6&q=%EB%8F%99%EA%B0%91%EB%82%B4%EA%B8%B0%20%EA%B3%BC%EC%99%B8%ED%95%98%EA%B8%B0"))!)!
         */
        parser = XMLParser(contentsOf:(URL(string:"http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?key=9441603806499445c9216fe146a530e2&targetDt=20170521"))!)!
        parser.delegate = self
        parser.parse()
        //tbData!.reloadData()
    }

    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        //if(elementName as NSString).isEqual(to: "dailyBoxOffice")
        if(elementName as NSString).isEqual(to: "dailyBoxOffice")
        {
            elements = NSMutableDictionary()
            elements = [:]
            
            title1 = NSMutableString()
            title1 = ""
            
            /*
            date = NSMutableString()
            date = ""
 
            imageurl = NSMutableString()
            imageurl = ""
            */
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String!)
    {
        
        if element.isEqual(to: "movieNm") {
            title1.append(string)
            //pageImages.append(thumbnailParser.getThumbnail(movieName: title1 as String))
        }
        /*
        else if element.isEqual("openDt") {
            date.append(string)
        }else if element.isEqual("thumbnail") {
            imageurl.append(string)
        }

        if element.isEqual("thumbnail") {
            imageurl.append(string)
        }
        */
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (elementName as NSString).isEqual(to: "dailyBoxOffice") {
            
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "movieNm" as NSCopying)
            
            }
            /*
            if !date.isEqual(nil) {
                elements.setObject(date, forKey: "openDt" as NSCopying)
            }
            if !imageurl.isEqual(nil){
                elements.setObject(date, forKey: "thumbnail" as NSCopying)
            }
            */
            /*
            if !imageurl.isEqual(nil){
                elements.setObject(imageurl, forKey: "thumbnail" as NSCopying)
            }
            */
            posts.add(elements)
        }
    }
    
    func loadPage(_ page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            frame = frame.insetBy(dx:10.0, dy: 0.0)
            
            // 3
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .scaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(_ page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for index in 0 ..< firstPage+1 {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for index in lastPage+1 ..< pageImages.count+1 {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!){
        loadVisiblePages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        pageImages.append(thumbnailParser.getThumbnail(movieName: "겟 아웃"))
        /*
        if let url = URL(string: "http://t1.search.daumcdn.net/thumb/R438x0.q85/?fname=http%3A%2F%2Fcfile189.uf.daum.net%2Fimage%2F156F1B10AB48241E6AB36C")
        {
            if let data = try? Data(contentsOf: url)
            {
                pageImages.append(UIImage(data: data)!)
                /*
                pageImages = [UIImage(data: data)!,
                              UIImage(named: "photo2.png")!,
                              UIImage(named: "photo3.png")!,
                              UIImage(named: "photo4.png")!,
                              UIImage(named: "photo5.png")!]
                 */
            }
        }

        
        pageImages.append(UIImage(named: "photo2.png")!)
        pageImages.append(UIImage(named: "photo3.png")!)
        pageImages.append(UIImage(named: "photo4.png")!)
        pageImages.append(UIImage(named: "photo5.png")!)
        var movieName = (posts[0] as AnyObject).value(forKey: "movieNm")
        
 
        pageImages = [UIImage(named: "photo1.png")!,
                      UIImage(named: "photo2.png")!,
                      UIImage(named: "photo3.png")!,
                      UIImage(named: "photo4.png")!,
                      UIImage(named: "photo5.png")!]
         */
        let pageCount = pageImages.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount{
            pageViews.append(nil)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
                                        height: pagesScrollViewSize.height)
        
        
        loadVisiblePages()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
