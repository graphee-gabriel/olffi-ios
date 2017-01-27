import UIKit

class UICenteredButton: UIButton
{
    
    let imageRatio = CGFloat(0.5)
    let titleMargin = CGFloat(8)
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)
        
        
        return CGRect(x: 0, y: contentRect.height - rect.height - titleMargin,
                      width: contentRect.width, height: rect.height)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        let titleRect = self.titleRect(forContentRect: contentRect)
        
        return CGRect(x: CGFloat(contentRect.width - rect.width)*imageRatio,
                      y: CGFloat(contentRect.height - titleRect.height - rect.height)*imageRatio,
                      width: rect.width, height: rect.height)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        if let image = imageView?.image {
            var labelHeight: CGFloat = 0.0
            
            if let size = titleLabel?.sizeThatFits(CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude)) {
                labelHeight = size.height
            }
            
            return CGSize(width: size.width, height: image.size.height + labelHeight - titleMargin)
        }
        
        return size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        centerTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        centerTitleLabel()
    }
    
    private func centerTitleLabel() {
        self.titleLabel?.textAlignment = .center
    }
}
