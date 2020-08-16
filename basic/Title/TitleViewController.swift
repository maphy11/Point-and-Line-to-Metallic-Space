//
// DrawingViewController.swift

import Metal
import simd
import QuartzCore
import UIKit

struct TextureVert {
    var vert:Vertex = Vertex()
    var uv:Float2 = Float2()
}

class TitleViewController : BaseViewController
{
    private var menuLineData:[Line] = [Line](repeating: Line(), count: 2)
    
    private var selectStartMesh = CAIMMetalQuadrangles<Vertex>(count: 1)
    private var textureView = CAIMMetalQuadrangles<TextureVert>(count: 1)
    private var titleTexture:CAIMMetalTexture = CAIMMetalTexture(name: "title")
    private var menuTexture:CAIMMetalTexture = CAIMMetalTexture(name: "menu")
    
    private var selectStartMeshPipeline:CAIMMetalRenderPipeline = CAIMMetalRenderPipeline()
    private var texturePipeline:CAIMMetalRenderPipeline = CAIMMetalRenderPipeline()
    
    private var isTouchStart = false
    private var isMenu:Bool = false
    private let y1:Float = (250.0/750.0) * Float(UIScreen.main.nativeBounds.size.width)
    private let x1:Float = (1055.0/1334.0) * Float(UIScreen.main.nativeBounds.size.height)
    private let y2:Float = (525.0/750.0) * Float(UIScreen.main.nativeBounds.size.width)
    private let x2:Float = (610.0/1334.0) * Float(UIScreen.main.nativeBounds.size.height)
    // 準備関数
    override func setup()
    {
        super.setup()
//        metal_view!.metalLayer.pixelFormat = menuTexture.metalTexture?.pixelFormat as! MTLPixelFormat
        
        setupTextureView()
        let p1 = Point(pos: Float2(0,y1), color: .black)
        let p2 = Point(pos: Float2(x1,0), color: .black)
        let p3 = Point(pos:Float2(x2,y2),color: .black)
        
        menuLineData[0] = Line(p1: p1, p2: p3, frameCount: 0, wid: 3)
        menuLineData[1] = Line(p1: p2, p2: p3, frameCount: 0, wid: 3)
    }
    
    override func setupMetalShader()
    {
        super.setupMetalShader()
        selectStartMeshPipeline.make
        {
            $0.vertexShader = CAIMMetalShader("vertLine")
            $0.fragmentShader = CAIMMetalShader("fragStandard")
        }
        texturePipeline.make
        {
            // シェーダを指定
            $0.vertexShader = CAIMMetalShader("texture2D")
            $0.fragmentShader = CAIMMetalShader( "fragTexture" )
//            guard(menuTexture.metalTexture != nil) else { return }
//            $0.colorAttachment.pixelFormat = menuTexture.metalTexture?.pixelFormat as! MTLPixelFormat
        }
    }
    
    func setupTextureView()
    {
//        let wid:Float = Float(UIScreen.main.bounds.width) * 2
//        let hgt:Float = Float(UIScreen.main.bounds.height) * 2
        let wid:Float = Float(view.pixelBounds.size.width)
        let hgt:Float = Float(view.pixelBounds.size.height)
        let v1 = Vertex(pos: Float2(0,hgt), frameCount: 0, color: CAIMColor().float4)
        let v2 = Vertex(pos: Float2(wid,hgt), frameCount: 0, color: CAIMColor().float4)
        let v3 = Vertex(pos: Float2(0,0), frameCount: 0, color: CAIMColor().float4)
        let v4 = Vertex(pos: Float2(wid,0), frameCount: 0, color: CAIMColor().float4)
        textureView[0].p1 = TextureVert(vert: v1, uv: Float2(0,1))
        textureView[0].p2 = TextureVert(vert: v2, uv: Float2(1,1))
        textureView[0].p3 = TextureVert(vert: v3, uv: Float2(0,0))
        textureView[0].p4 = TextureVert(vert: v4, uv: Float2(1,0))
    }
    
    func genSelectStartMesh()
    {
        let color:CAIMColor = .white
        selectStartMesh[0].p1 = Vertex(pos: Float2(0,0), frameCount: 0, color: color.float4)
        selectStartMesh[0].p2 = Vertex(pos: Float2(0,y1), frameCount: 0, color: color.float4)
        selectStartMesh[0].p3 = Vertex(pos: Float2(x1,0), frameCount: 0, color: color.float4)
        selectStartMesh[0].p4 = Vertex(pos: Float2(x2,y2), frameCount: 0, color: color.float4)
    }
    
    // 繰り返し処理関数
    override func update()
    {
        super.update()
        isTouchStart = false
        if(isMenu == false)
        {
            if(metal_view!.releasePixelPos.count > 0)
            {
                isMenu = true
                metal_view!.releasePixelPos.removeAll()
            }
            metal_view?.execute( renderFunc: self.render )
            return
        }
//        Line Generation
        genTempline()
        if(metal_view!.releasePixelPos.count > 0)
        {
            for i in 0 ..< metal_view!.releasePixelPos.count
            {
                
                let p = metal_view!.releasePixelPos[i]
                let color = CAIMColor(0,0,0,0.0)
                let point = VertexGenerator.genPoint(pos: p, color: color)
                determinedPoint.append(point)
            }
        }
        let isTapDecision = TitleDecsion.TapDecision(tPoses: metal_view!.releasePixelPos, lines: menuLineData)
        let isLineDecision = TitleDecsion.LineDecision(dp: &determinedPoint, menuLines: menuLineData, lines: &lineData)
        if(isTapDecision || isLineDecision)
        {
            let nextvc = PlayViewController()
            self.present(nextvc, animated: false, completion: nil)
        }
        let isTapSerection = TitleSerection.TapSerection(touchPoints: metal_view!.touchPixelPos, l1: menuLineData[0], l2: menuLineData[1])
        let isLineSerection = TitleSerection.LineSerection(l1: menuLineData[0], l2: menuLineData[1], tempLine: tempLineData)
        if(isTapSerection || isLineSerection)
        {
            genSelectStartMesh()
            isTouchStart = true
        }
        metal_view!.releasePixelPos.removeAll()
        
        if(tempLineData != nil)
        {
            lineData.append(tempLineData!)
        }
        // ライン情報からメッシュ情報を更新
        if lineData.count > 0
        {
            lineBuffer.genLineMesh(linesData: lineData)
        }
        metal_view?.execute( renderFunc: self.render )
    }
    
    override func render(encoder: MTLRenderCommandEncoder)
    {
        if(isTouchStart)
        {
            encoder.use(selectStartMeshPipeline)
            {
                $0.setVertexBuffer(mat, index: 1)
                $0.drawShape(selectStartMesh,index: 0)
            }
        }
        encoder.use(texturePipeline)
        {
            $0.setVertexBuffer(mat, index: 1)
            if(isMenu)
            {
                $0.setFragmentTexture(menuTexture.metalTexture, index: 0)
            }
            else
            {
                $0.setFragmentTexture(titleTexture.metalTexture, index: 0)
            }
            $0.drawShape(textureView,index: 0)
        }
        super.render(encoder: encoder)
    }
}
