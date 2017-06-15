//
//  HCPieChartView.swift
//  HCFormTools
//
//  Created by UltraPower on 2017/6/14.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit


class HCPieChartView: UIView {
    var popAnimation:Bool = true
    
    var kRadiusConst:CGFloat = 100.0 // 圆的半径
    var column:Int = 3        // 图标列数
    var margin:CGFloat = 10.0 // 图标间距
    var wh:CGFloat = 20.0     // 图标宽高
    
    lazy var centerP: CGPoint = { // 设置圆的中心
        return CGPoint(x: self.center.x, y:self.kRadiusConst)
    }()
    
    var valueRegion:[(CGFloat,CGFloat,CGFloat,UIColor)] = [(CGFloat,CGFloat,CGFloat,UIColor)]()
    
    
    var dataList:[CGFloat] = [] {
        didSet {
            if dataList.count > 0 {
                valueRegion.removeAll()
                setNeedsDisplay()
            }
        }
    }
    
    var colorList:[UIColor] = []{
        didSet {
            if colorList.count > 0 {
                setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let ctxt = UIGraphicsGetCurrentContext()
      
        let sum = dataList.reduce(0) { $0 + $1 }
        
        var startAngle:CGFloat = 0
        var endAngle:CGFloat = 0

        var index = 0
        for value in dataList {
            // 画扇形图
            let persents = value / sum
            endAngle = persents * CGFloat.pi * 2.0 + startAngle
            ctxt?.addArc(center: centerP, radius: kRadiusConst, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            let color = UIColor.randomColor()
            ctxt?.addLine(to: centerP)
            ctxt?.setFillColor(color.cgColor)
            
            // 画图标
            let col:Int = index % column
            let row:Int = index / column
            let x = margin + (margin + wh) * CGFloat(col) + 50 * CGFloat(col)
            let y = centerP.y + kRadiusConst + margin + (margin + wh) * CGFloat(row)
            ctxt?.setLineWidth(2.0)
            ctxt?.addRect(CGRect(x: x, y: y, width: wh, height: wh))
            ctxt?.setFillColor(color.cgColor)
            
            ctxt?.fillPath()
            
            // 画数字
            let persentstr = String(format: "%.2f%%", persents * 100)
            NSString(string: persentstr).draw(in: CGRect(x: x + wh + 4, y: y + 4, width: 50, height: wh), withAttributes: [NSForegroundColorAttributeName : UIColor.white])
        
            
            let valueR = (startAngle, endAngle, persents,color)
            valueRegion.append(valueR)
            
            startAngle = endAngle
            index += 1
        }
        
    }
}


extension HCPieChartView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = (touches as NSSet).anyObject() as! UITouch
        let point = touch.location(in: self)
        
        let distance = point.distanceTo(centerP)
        
        guard distance <= 100 else {    // 圆外
            return
        }
        
        // 圆内
        let startPoint = CGPoint(x: centerP.x + kRadiusConst, y: centerP.y)
        
        let pointRadius = point.angleInArc(centerP, point: startPoint)
        
        
        // 确定当前点所在区间
        var index = 0
        for valueR in valueRegion {
            if pointRadius >= valueR.0 && pointRadius <= valueR.1 {
                
                presentValues(point: point, value: valueR)
                
                break
            }
            
            index += 1
        }
    }
}

extension HCPieChartView {
    func presentValues(point:CGPoint, value:(CGFloat,CGFloat,CGFloat,UIColor))  {
        let persentstr = String(format: "%.2f%%", value.2 * 100)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.layer.cornerRadius = 25
        label.layer.masksToBounds = true
        label.center = point
        label.backgroundColor = value.3
        label.text = persentstr
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
        
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut, animations: {
            label.frame = CGRect(x: point.x, y: -80, width: 50, height: 50)
        }, completion: { (_) in
            label.removeFromSuperview()
        })

    }
}

extension CGPoint {
    // 获取两点间的距离
    func distanceTo(_ point: CGPoint) -> CGFloat {
        let deltaX = x - point.x
        let deltaY = y - point.y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
    
    // 获取圆内一点的弧度值
    func angleInArc(_ basePoint: CGPoint, point: CGPoint) -> CGFloat {
        
        let deltaY = basePoint.y - y
        
        let a = basePoint.x - x;
        let b = basePoint.y - y;
        let c = basePoint.x - point.x;
        let d = basePoint.y - point.y;
        
        let rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
        
        return deltaY > 0 ? 2.0 * CGFloat.pi - rads : rads
       
    }
    
}

extension UIColor {
    class func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0)
    }
}
