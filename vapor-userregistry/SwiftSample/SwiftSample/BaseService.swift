//
//  BaseService.swift
//  SwiftSample
//
//  Created by qbuser on 15/02/17.
//  Copyright © 2017 qbuser. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class BaseService: NSObject {
   
    class func requestGetURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        Alamofire.request(strURL, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
//                success(resJson)
                if resJson["code"] == 200 || resJson["code"].stringValue.lengthOfBytes(using: String.Encoding.utf8) == 0
                {
                    success(resJson)
                }
                else
                {
                    let error = NSError.init(domain: "error", code: resJson["code"].int! , userInfo: [NSLocalizedDescriptionKey:resJson["message"].stringValue])
                    failure(error)
                    
                    
                }
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }

    class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
//                success(resJson)
                if resJson["code"] == 200 || resJson["code"].stringValue.lengthOfBytes(using: String.Encoding.utf8) == 0
                {
                    success(resJson)
                }
                else
                {
                    let error = NSError.init(domain: "error", code: resJson["code"].int! , userInfo: [NSLocalizedDescriptionKey:resJson["message"].stringValue])
                    failure(error)
                    
                    
                }
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
//                success(resJson)
//                let resJson = JSON(response.result.value!)
                if resJson["code"] == 200 || resJson["code"].stringValue.lengthOfBytes(using: String.Encoding.utf8) == 0
                {
                    success(resJson)
                }
                else
                {
                    let error = NSError.init(domain: "error", code: resJson["code"].int! , userInfo: [NSLocalizedDescriptionKey:resJson["message"].stringValue])
                    failure(error)
                    
                    
                }
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestMultiPartURL(_ strURL : String,image:UIImage?, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
//        manager.request("yourUrl", method: .post, parameters: ["parameterKey": "value"])
//            .responseJSON {
//                response in
//                switch (response.result) {
//                case .success:
//                    //do json stuff
//                    break
//                case .failure(let error):
//                    if error._code == NSURLErrorTimedOut {
//                        //timeout here
//                    }
//                    print("\n\nAuth request failed with error:\n \(error)")
//                    break
//                }
//        }
        
        manager.upload(
            multipartFormData: { multipartFormData in
                
        if let imageData = image {
            multipartFormData.append(UIImagePNGRepresentation(imageData)!,
                                     withName: "image",
                                     fileName: "image.jpg",
                                     mimeType: "image/jpeg")

                }
            for (key, value) in params! {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        },
            to: root+addCar,
            headers: headers,
            encodingCompletion: { encodingResult in
              print(encodingResult)
                
                
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    
                    
                    
                    upload.responseJSON { response in
                        
                        if response.result.isSuccess {
                            let resJson = JSON(response.result.value!)
                            if resJson["code"] == 200 || resJson["code"].stringValue.lengthOfBytes(using: String.Encoding.utf8) == 0
                            {
                                success(resJson)
                            }
                            else
                            {
                                let error = NSError.init(domain: "error", code: resJson["code"].int! , userInfo: [NSLocalizedDescriptionKey:resJson["message"].stringValue])
                                failure(error)

  
                            }
                        }
                        if response.result.isFailure {
                            let error : Error = response.result.error!
                            failure(error)
                        }

//                        
//                        //                    self.delegate?.showSuccessAlert()
//                        
//                        print(response.request ?? "sa")  // original URL request
//                        
//                        print(response.response ?? "asa") // URL response
//                        
//                        print(response.data ?? "asa")     // server data
//                        
//                        print(response.result)   // result of response serialization
//                        
//                        //                        self.showSuccesAlert()
//                        
//                        //                    self.removeImage("frame", fileExtension: "txt")
//                        
//                        if let JSON = response.result.value {
//                            
//                            print("JSON: \(JSON)")
//                            
//                        }
                        
                    }
                    
                    
                    
                case .failure(let encodingError):
                    
                    //                self.delegate?.showFailAlert()
                    
                    print(encodingError)
                    
                }
                
                
                
        }
        )

    }
}
