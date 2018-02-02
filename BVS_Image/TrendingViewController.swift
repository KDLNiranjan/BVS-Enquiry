//
//  TrendingViewController.swift
//  Vikatan_Demo
//
//  Created by Kutung-PC48 on 12/06/17.
//  Copyright © 2017 Muthukumaresh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class TrendingViewController: UIViewController {

    @IBOutlet weak var CustomScrollView: UIScrollView!
    
    
    var arrRes:Array<JSON>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        if let url = URL(string: "http://107.23.137.165:4000/api/trending") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest.addValue("vikatan", forHTTPHeaderField: "api-key")
            
            Alamofire.request(urlRequest).responseData { (resData) -> Void in
                let strOutput = JSON(resData.result.value!)
                
                
                print(strOutput)
//                
                self.arrRes = strOutput["response"].arrayValue
                
                self.setUptoScrollView(strOutput["response"].arrayValue)
                
//        self.generateButtonsForView()

            }
        }
    
        
        
        
        let leftButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.backButtonPressed))
        navigationItem.leftBarButtonItem = leftButton
       
     
        
        
    }
    
 /// Muthukumaresh
    
    func setUptoScrollView(_ valArray: [JSON]) {
        
  /*
        var xPos = CGFloat()
        var yPos = CGFloat()
        var frame = CGRect()
        for receivedTag in valArray{
        
        xPos = (CGFloat(arc4random_uniform(UInt32((self.view?.frame.size.width)!))))
        yPos = (CGFloat(arc4random_uniform(UInt32((self.view?.frame.size.height)!))))
        

        if (xPos > ((self.view?.bounds.width)! - (self.view?.bounds.width)! * 0.20)){
            
            // arc4random()%Int32(viewWidth)
           
            
            xPos = xPos.truncatingRemainder(dividingBy:((self.view?.bounds.width)! - (self.view?.bounds.width)! * 0.20))
            
            let trendingTags = UIButton(frame: frame)
            
            
            //  buttonY = buttonY + 50
            
            
            
            trendingTags.layer.cornerRadius = 10
            trendingTags.setTitle("\(receivedTag["name"])", for: UIControlState.normal)
            trendingTags.titleLabel?.text = "\(receivedTag["name"])"
            trendingTags.titleLabel!.font =  UIFont(name: "Baamini", size: CGFloat(receivedTag["size"].floatValue))
            trendingTags.titleLabel?.adjustsFontSizeToFitWidth = true
            trendingTags.addTarget(self, action: #selector(TrendingViewController.buttonAction), for: UIControlEvents.touchUpInside)
            
            trendingTags.setTitleColor(UIColor.gray, for: .normal)
            CustomScrollView.addSubview(trendingTags)
            CustomScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: yPos + 50)
            
            frame.origin.x+=frame.size.width+20
            
          
        }
        if (yPos > ((self.view?.bounds.height)! - (self.view?.bounds.width)! * 0.20)){
            
            yPos = yPos.truncatingRemainder(dividingBy:((self.view?.bounds.height)! - (self.view?.bounds.width)! * 0.20))
         
            
        }
            let trendingTags = UIButton(frame: frame)
            
            
            //  buttonY = buttonY + 50
            
            
            
            trendingTags.layer.cornerRadius = 10
            trendingTags.setTitle("\(receivedTag["name"])", for: UIControlState.normal)
            trendingTags.titleLabel?.text = "\(receivedTag["name"])"
            trendingTags.titleLabel!.font =  UIFont(name: "Baamini", size: CGFloat(receivedTag["size"].floatValue))
            trendingTags.titleLabel?.adjustsFontSizeToFitWidth = true
            trendingTags.addTarget(self, action: #selector(TrendingViewController.buttonAction), for: UIControlEvents.touchUpInside)
            
            trendingTags.setTitleColor(UIColor.gray, for: .normal)
            CustomScrollView.addSubview(trendingTags)
            CustomScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: yPos + 50)
            
            frame.origin.x+=frame.size.width+20

        }
        
    */
        
        
        
        var frame:CGRect
        var x:CGFloat = 0
        var y:CGFloat = 0
        var count:CGFloat=0;
        
        
        
        
        
  //      var buttonY: CGFloat = 20  // our Starting Offset, could be 0
        for receivedTagName in valArray {
            
            
   //         print(receivedTagName["name"])
            
            
            let tagWidth = receivedTagName["name"].stringValue.characters.count
            
       //     print(tagWidth)
            
            frame = CGRect(x: x, y: y, width: self.CustomScrollView.frame.width/3, height: 30)
        
            if(frame.origin.x >= (self.CustomScrollView.frame.width - frame.width))
            {
                x = 0
                count += 1
                y = +y
                
            }
            else
            {
               // y = 0
                x = x + frame.width
                y = y + 25
                
            }
            
            
            
            
            let trendingTags = UIButton(frame: frame)
            print(trendingTags)
            
          //  buttonY = buttonY + 50
                
           //     28,26,24,20,18,14
            
            
            
        //    trendingTags.layer.cornerRadius = 10
            trendingTags.setTitle("\(receivedTagName["name"])", for: UIControlState.normal)
            trendingTags.titleLabel?.text = "\(receivedTagName["name"])"
            if receivedTagName["size"] == 14 {
                trendingTags.setTitleColor(UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5), for: .normal)
            }
            else if receivedTagName["size"] == 18 {
                trendingTags.setTitleColor(UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6), for: .normal)
            }
            else if receivedTagName["size"] == 20 {
                trendingTags.setTitleColor(UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.7), for: .normal)
            }
            else if receivedTagName["size"] == 24 {
                trendingTags.setTitleColor(UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8), for: .normal)
            }
            else if receivedTagName["size"] == 26 {
                trendingTags.setTitleColor(UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.9), for: .normal)
            }
            else {
                trendingTags.setTitleColor(UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0), for: .normal)
            }
            
          
            
            if receivedTagName["content_type"] == "TA" {
            trendingTags.titleLabel!.font =  UIFont(name: "Baamini", size: CGFloat(receivedTagName["size"].floatValue))
            }
            else{
                trendingTags.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: CGFloat(receivedTagName["size"].floatValue))
            }
            
            trendingTags.titleLabel?.adjustsFontSizeToFitWidth = true
            trendingTags.addTarget(self, action: #selector(TrendingViewController.buttonAction), for: UIControlEvents.touchUpInside)

          //  trendingTags.setTitleColor(UIColor.gray, for: .normal)
            CustomScrollView.addSubview(trendingTags)
            CustomScrollView.contentSize = CGSize(width: self.CustomScrollView.frame.size.width, height: y + 50)
            
            frame.origin.x+=frame.size.width+20
            
            
        }
 
    }
    
    func buttonAction(){
        
        
        
        
        
        
    }
    
    func generateButtonsForView() {
        
        
        let viewWidth: CFloat = CFloat()
        let viewHeight: CFloat = CFloat()
        let initialView:UIButton = UIButton(frame: CGRect(x: CGFloat(arc4random().distance(to: UInt32(viewWidth))), y: CGFloat(arc4random().distance(to: UInt32(viewHeight))), width: 100, height: 30))
        initialView.backgroundColor = UIColor.red
        self.CustomScrollView.addSubview(initialView)
        var numViews: Int32 = 0
        while numViews < 19 {
            var goodView: Bool = true
            let candidateView: UIButton = UIButton(frame: CGRect(x: CGFloat(arc4random().distance(to: UInt32(viewWidth))), y: CGFloat(arc4random().distance(to: UInt32(viewHeight))), width: 100, height: 30))
            candidateView.backgroundColor = UIColor.red
            for placedView in self.CustomScrollView.subviews {
                if candidateView.frame.insetBy(dx: -10, dy: -10).intersects(placedView.frame) {
                    goodView = false
                    break
                }
            }
            if (goodView) {
                self.CustomScrollView.addSubview(candidateView)
                numViews += 1;
            }
        }
    }
    
    
//    func tap(_ sender: UIButton) {
//        print("\(Int(sender.tag))")
//        print("\(Int(sender.tag))")
//        for i in 0..<resultArray.count {
//            let dict: [AnyHashable: Any]? = (resultArray[i] as? [AnyHashable: Any])
//            if CInt(dict["categoryId"]) == Int(sender.tag) {
//                if CInt(dict["active"]) == 0 {
//                    let dictNew: [AnyHashable: Any] = [
//                        "active" : "1",
//                        "categoryId" : dict["categoryId"],
//                        "categoryName" : dict["categoryName"]
//                    ]
//                    
//                    resultArray.remove(at: i)
//                    resultArray.insert(dictNew, at: i)
//                }
//                else {
//                    let dictNew: [AnyHashable: Any] = [
//                        "active" : "0",
//                        "categoryId" : dict["categoryId"],
//                        "categoryName" : dict["categoryName"]
//                    ]
//                    
//                    resultArray.remove(at: i)
//                    resultArray.insert(dictNew, at: i)
//                }
//            }
//        }
//        setUptoScrollView(resultArray)
//    }

    func setup(_ urlString: URL) {
//        let keyVal: String = "{\"supplierID\":\"0\"}"
//        let new1: [AnyHashable: Any] = [
//            "targetItem" : keyVal
//        ]
//        
//        let setupData: [AnyHashable: Any] = [
//            "msgType" : "30",
//            "properties" : new1
//        ]
        
        //convert object to data
//        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: setupData, options: .init(rawValue: nil))
//        var request = NSMutableURLRequest()
//        request.url = urlString
//        request.HTTPMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.HTTPBody = jsonData
//        var response: URLResponse?
//        var err: Error?
//        let responseData: Data? = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
//        resultDict = try? JSONSerialization.jsonObject(withData: responseData, options: NSJSONReadingMutableLeaves)
    }
    
    func backButtonPressed() {
        print("back Clicked")
        self.navigationController?.popViewController(animated: true)
    }
    
}
