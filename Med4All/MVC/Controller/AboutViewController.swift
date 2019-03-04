//
//  AboutViewController.swift
//  Med4All
//
//  Created by Yahia El-Dow on 4/10/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class AboutViewController: UIViewController , YTPlayerViewDelegate {
    @IBOutlet weak var youtube_webView: YTPlayerView!
    @IBOutlet weak var about_btn_playVideo: UIButton!
    private let about_loader = _Indicator()
    
    

    var userAskToPlayVideo = false
    var videoIsReady = false
    
    @IBAction func about_playVideo(_ sender: Any) {

        self.userAskToPlayVideo = true
        self.view.addSubview(about_loader)
        if self.videoIsReady {
            self.about_btn_playVideo.alpha = 0
            self.youtube_webView.playVideo()
            self.about_loader.removeFromSuperview()
        }
 
    }
    
    override func loadView() {
        super.loadView()
        let videoID = "MfpIKk7fgw8"
        let param  = [
                      "rel":"0" ,
                      "controls":"0" ,
                      "showinfo":"0" ,
                      "autoplay":"0" ,
                      "frameborder":"0"];
        youtube_webView.backgroundColor = .clear
        youtube_webView.load(withVideoId: videoID, playerVars: param)
        youtube_webView.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("ready")
        self.videoIsReady = true
        if self.userAskToPlayVideo {
            self.youtube_webView.playVideo()
            self.about_btn_playVideo.alpha = 0
            self.about_loader.removeFromSuperview()

        }
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .paused :
            self.about_btn_playVideo.alpha = 1
            break
        case .ended :
            self.about_btn_playVideo.alpha = 1
            break
        default:
            break
        }
    }
    @IBAction func aboutDismiss(_ sender: Any) {
        UIViewController.root().dismiss(animated: true, completion: nil)
       // OpenViewController.openWith(controller_name: "RequestVC")
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
     /*  let youtubeLink = "https://www.youtube.com/embed/MfpIKk7fgw8?rel=0&amp;controls=0&amp;showinfo=0;autoplay=1"
     let webViewWidth = self.youtube_webView.frame.size.width
     let webViewHeight = self.youtube_webView.frame.size.height
     let webViewHtml = "<html><body><iframe width=\"375.0\" height=\"450.0\" src=\"https://www.youtube.com/embed/MfpIKk7fgw8?rel=0&amp;controls=0&amp;showinfo=0;autoplay=1\" frameborder=\"0\" allowfullscreen></iframe></body></html>" ;
     */
    */

}
extension AboutViewController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
}
