import UIKit

class MainController: UITableViewController, UIGestureRecognizerDelegate {
    
    var panRecognizer: UIPanGestureRecognizer!
    
    var gotStart: Bool = true
    
    var startTouch: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.bounces = false
        
        self.panRecognizer = self.tableView.panGestureRecognizer
        self.panRecognizer.addTarget(self, action: "pan:")
        self.tableView.addGestureRecognizer(self.panRecognizer)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func pan(rec:UIPanGestureRecognizer){
        
        if let parent = self.parentViewController as? ContainerController {
            
            var y = self.tableView.contentOffset.y
            var touch = rec.locationInView(self.view)
            
            // JUMPING y
            println(touch.y)
            
            if y == -64 {
                
                if self.gotStart  || y < -64 || y > -64 {
                    
                    self.startTouch = touch
                    self.gotStart = false
                    
                } else {
                    
                    if rec.state == .Changed {
                        
                        var changedVerticalHeight = (self.startTouch.y - touch.y)*(-1)
                        
                        if changedVerticalHeight <= parent.view.frame.size.height && touch.y >= changedVerticalHeight {
                            
                            parent.foregroundTopSpace.constant = changedVerticalHeight
                            parent.foregroundBottomSpace.constant = -changedVerticalHeight
                        }
                        
                    } else if rec.state == .Ended {
                        
                        parent.foregroundTopSpace.constant = 0
                        parent.foregroundBottomSpace.constant = 0
                        
                        self.gotStart = true
                    }
                }
            }
        }
    }
    
    // Default table stuff, not related to problem
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell_ : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CELL_ID") as? UITableViewCell
        if(cell_ == nil){
            cell_ = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL_ID")
        }
        
        cell_!.textLabel!.text = "Row " + String(indexPath.row)
        
        return cell_!
    }
}

