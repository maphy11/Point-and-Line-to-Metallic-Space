//
// DrawingViewController.swift
import Metal
import simd
import QuartzCore
import AVFoundation

struct Triangle{
    var p1:Point = Point()
    var p2:Point = Point()
    var p3:Point = Point()
}

class PlayViewController : BaseViewController
{
    private var trianglePipeline:CAIMMetalRenderPipeline = CAIMMetalRenderPipeline()
    private var triangleData = [Triangle]()
    private var triangles : TriangleMesh = TriangleMesh()
    private var audioManager = AudioManager()

    // 準備関数0
    override func setup()
    {
        super.setup()
    }
    
    override func setupMetalShader()
    {
        super.setupMetalShader()
        
        trianglePipeline.make
        {
            $0.vertexShader = CAIMMetalShader("vertTriangle")
            $0.fragmentShader = CAIMMetalShader( "fragStandard" )
        }
    }
    // 繰り返し処理関数
    override func update()
    {
        super.update()
        
        genTempline()
        
        determinedLine()
        
        metal_view!.releasePixelPos.removeAll()
        
        if(lineData.count >= 3)
        {
            //            print("lineData over 3")
            //            print(lineData)
            var InterSectionPoint:[Point] = [Point]()
            for i in 0 ..< lineData.count
            {
                let point:Point? = VertexGenerator.culIntersectionPoint(l1: lineData[i], l2: lineData[(i+1)%lineData.count])
                
                if(point != nil) { InterSectionPoint.append(point!) }
            }
            
            //            print("The number of InterSectionPoint is \(InterSectionPoint.count)")
            
            if(InterSectionPoint.count >= 3)
            {
                let tris:Triangle? = VertexGenerator.genTriangle(points: InterSectionPoint)
                if(tris != nil)
                {
                    triangleData.append(tris!)
                }
            }
            
            lineData.removeAll()
            //            print(lineData.count)
        }
            
        else if(tempLineData != nil)
        {
            lineData.append(tempLineData!)
            //print("make tempLine")
        }
        
        audioManager.Play(count: triangleData.count)
        
        if(triangleData.count > 5)
        {
            triangleData.remove(at: 0)
        }
        
        if(lineData.count > 0)
        {
            lineBuffer.genLineMesh(linesData: lineData)
        }
        if(triangleData.count > 0)
        {
            triangles.genTriangleMesh(triangleDatas: triangleData)
        }
        
        if ((lineData.count > 0) || (triangleData.count > 0))
        {
            metal_view?.execute(renderFunc: self.render)
        }
        
        else
        {
            metal_view?.execute()
        }
    }
    
    // Metalで実際に描画を指示する関数
    override func render( encoder:MTLRenderCommandEncoder )
    {
        super.render(encoder: encoder)
        
        if(triangleData.count > 0)
        {
            encoder.use(trianglePipeline)
            {
                $0.setVertexBuffer( mat, index: 1 )
//                $0.setFragmentBuffer(bounds, index: 2)
                // 円描画用の四角形データ群の頂点をバッファ0番にセットし描画を実行
                $0.drawShape( triangles.triangles, index: 0 )
            }
        }
    }
}
