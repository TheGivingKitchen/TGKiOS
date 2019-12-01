//
//  StabilityNetClusterAnnotationView.swift
//  TGK
//
//  Created by Jay Park on 12/1/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class StabilityNetClusterAnnotationView:MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: CustomCluster
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            self.image = self.drawCount(cluster.memberAnnotations.count)
        }
    }

    private func drawCount(_ innerNumber:Int) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            UIColor.tgkOrange.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()

            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 2, y: 2, width: 36, height: 36)).fill()

            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
            let text = "\(innerNumber)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
