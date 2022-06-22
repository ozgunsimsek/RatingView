import UIKit


open class RatingView: UIView {
    
    // MARK: - Properties
    
    /// Rating value between 0 and 5.
    ///
    /// The default is `3.14`.
    @IBInspectable
    open var rating: Double = 3.14{
        didSet{
            updateRating()
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setImages()
        updateRating()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
    }
    
    
    // MARK: - Private
    
    private let defaultImageWidth: CGFloat = 60
    private let defaultImageHeight: CGFloat = 12
    
    private enum imageType {
        case fill
        case empty
    }
    
    private var fillImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .left
        iv.clipsToBounds = true
        return iv
    }()
    
    private var emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .right
        iv.clipsToBounds = true
        return iv
    }()
    
    private func setupViews() {
        addSubview(fillImageView)
        addSubview(emptyImageView)
    }
    
    private func setImages() {
        fillImageView.image = resizeImage(image: .fill)
        emptyImageView.image = resizeImage(image: .empty)
    }
    
    private func resizeImage(image: imageType) -> UIImage? {
        
        let widthRatio = self.frame.width / defaultImageWidth
        let heightRatio = self.frame.height / defaultImageHeight
        let ratio = min(widthRatio, heightRatio)
        
        let newWidth = defaultImageWidth * ratio
        let newHeight = defaultImageHeight * ratio
        
        let imageName = image == .fill ? "star-fill-icon" : "star-empty-icon"
        guard let image = UIImage(named: imageName, in: .module, compatibleWith: nil) else { return nil}
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func updateRating() {
        let imageWidth = fillImageView.image?.size.width ?? 0
        let imageHeight = fillImageView.image?.size.height ?? 0
        let optimizedRating = min(5, max(rating, 0))
        let fillRatio = CGFloat(optimizedRating) / 5
        let emptyRatio = 1 - fillRatio
        fillImageView.frame = CGRect(x: 0, y: 0, width: imageWidth * fillRatio, height: imageHeight)
        emptyImageView.frame = CGRect(x: imageWidth * fillRatio, y: 0, width: imageWidth * emptyRatio, height: imageHeight)
    }
    
}
