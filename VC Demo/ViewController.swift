//
//  ViewController.swift
//  VC Demo
//
//  Created by Tobias Scholze on 03.06.16.
//  Copyright © 2016 Tobias Scholze. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // MARK: - Outlets -
    
    @IBOutlet weak var loadingView  : UIView!
    @IBOutlet weak var imageView    : UIImageView!
    @IBOutlet weak var tagsLabel    : UILabel!
    
    
    // MARK:  Private variables -
    
    private var imagePicker: UIImagePickerController!
    private var showCamera = true
    
    
    // MARK: - Overriding UIViewController methods -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCameraView()
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        guard showCamera else
        {
            return
        }
        
        showCameraView()
    }
    
    
    // MARK: - Private Helper -
    
    private func setupCameraView()
    {
        imagePicker                 = UIImagePickerController()
        imagePicker.allowsEditing   = false
        imagePicker.delegate        = self
        imagePicker.sourceType      = .Camera
    }
    
    
    private func showCameraView()
    {
        loadingView.alpha = 1
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}


// MARK: UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate
{
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        showCamera          = false
        loadingView.alpha   = 0
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        imageView.image = image
        showCamera      = false
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let resizedImage    = image.resizeInScaleToWidth(width: 500)
        let manager         = CognitiveService()
        
        manager.analyzeImage(resizedImage) { (result, error) -> (Void) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                guard error == nil else
                {
                    self.tagsLabel.text = "Error occured: \(error?.localizedDescription)"
                    return
                }
                
                if result?.count == 0
                {
                    self.tagsLabel.text = "No tags found :("
                }
                    
                else
                {
                    guard let tags = result else
                    {
                        return
                    }
                    
                    self.tagsLabel.text = "The image may contains: \(tags.joinWithSeparator(", "))"
                }
                
                // Hide loading view
                UIView.animateWithDuration(0.25, animations: {
                    self.loadingView.alpha = 0
                })
            })
        }
    }
    
    
    // MARK: - Action -
    
    @IBAction func retakeTapped(sender: AnyObject)
    {
        showCameraView()
    }
    
}


// MARK: - UINavigationControllerDelegate -

extension ViewController: UINavigationControllerDelegate
{
    
}
