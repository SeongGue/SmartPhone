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
    @IBOutlet weak var SearchWord: UITextField!

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
    
    /*
    @IBAction func senderSearchWord(_ sender: Any) {
        performSegue(withIdentifier: "Search Word", sender: SearchWord.text)
    }
    */
    func beginParsing()
    {
        let todaysDate = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        var DateInFormat = dateFormatter.string(from: todaysDate as Date)
        DateInFormat = String((Int(DateInFormat)! - 1))
        
        posts = []
        parser = XMLParser(contentsOf:(URL(string:"http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?key=9441603806499445c9216fe146a530e2&targetDt=" + DateInFormat))!)!
        parser.delegate = self
        parser.parse()
    }

    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString

        if(elementName as NSString).isEqual(to: "dailyBoxOffice")
        {
            elements = NSMutableDictionary()
            elements = [:]
            
            title1 = NSMutableString()
            title1 = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String!)
    {
        
        if element.isEqual(to: "movieNm") {
            title1.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (elementName as NSString).isEqual(to: "dailyBoxOffice") {
            
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "movieNm" as NSCopying)
            
            }

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

        for i in 0..<posts.count{
            let movieName = (posts.object(at: i) as AnyObject).value(forKey: "movieNm") as! NSString as String
            pageImages.append(thumbnailParser.getThumbnail(movieName: movieName))
        }

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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        guard let rvc = dest as? SearchResultViewController else {
            return
        }
        rvc.searchWord = SearchWord.text!
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
