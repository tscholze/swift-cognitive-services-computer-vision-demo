//
//  CognitiveServiceConfiguration.swift
//  VC Demo
//
//  Created by Tobias Scholze on 03.06.16.
//  Copyright © 2016 Tobias Scholze. All rights reserved.
//

import Foundation
import UIKit

struct CognitiveServiceConfiguration
{
    // MARK: - API key -
    
    static let ApiKey = "<API_KEY>"
    static let ApiUrl = "https://api.projectoxford.ai/vision/v1.0/analyze"
    
    
    // MARK: - URL fragments -
    
    static let FragmentTags = "visualFeatures=Tags"
    
    
    // MARK: - Analyze configuration -
    
    static let CompressionFactor: CGFloat   = 0.9
    static let RequiredConfidence           = 0.75
}
