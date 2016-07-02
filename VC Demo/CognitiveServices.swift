//
//  CognitiveServices.swift
//  VC Demo
//
//  Created by Tobias Scholze on 03.06.16.
//  Copyright © 2016 Tobias Scholze. All rights reserved.
//

import Foundation
import UIKit


class CognitiveService
{
    // MARK: - Private variables -
    
    typealias RequestResult = ([String]?, NSError?) -> Void
    
    
    // MARK: - Workers -
    
    func analyzeImage(image: UIImage, callback: RequestResult)
    {
        let string = "\(CognitiveServiceConfiguration.ApiUrl)/?\(CognitiveServiceConfiguration.FragmentTags)"
        
        guard let url = NSURL(string: string) else
        {
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(CognitiveServiceConfiguration.ApiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        let requestData     = UIImageJPEGRepresentation(image, CognitiveServiceConfiguration.CompressionFactor)
        request.HTTPBody    = requestData
        request.HTTPMethod  = "POST"
        
        let session = NSURLSession.sharedSession()
        let task    = session.dataTaskWithRequest(request) { (data, response, error) in
        
            guard error == nil else
            {
                callback(nil, error)
                return
            }
            
            guard let _data = data else
            {
                callback(nil, nil)
                return
            }
            
            do
            {
                let json    = try NSJSONSerialization.JSONObjectWithData(_data, options: NSJSONReadingOptions.AllowFragments)
                var result  = [String]()
                
                guard let dictionary = json as? Dictionary<String, AnyObject> else
                {
                    return
                }
            
                let tags = dictionary["tags"]
                
                guard let typedTags = tags as? Array<Dictionary<String, AnyObject>> else
                {
                    return
                }
                
                for tag in typedTags
                {
                    let confidence = tag["confidence"] as! Double
                    
                    if confidence > CognitiveServiceConfiguration.RequiredConfidence
                    {
                        guard let name = tag["name"] as? String else
                        {
                            return
                        }
                        
                        result.append(name)
                    }
                }
            
                callback(result, nil)
            }
                
            catch _
            {
                callback(nil, error)
                return
            }
        }
        
        task.resume()
    }
}
