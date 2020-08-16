//
// DrawingViewController.swift

import Metal
import simd
import QuartzCore



class BaseViewController : CAIMViewController
{
//    Metalビュー
    var metal_view:CAIMMetalView?
//    Pipeline
    var linePipeline:CAIMMetalRenderPipeline = CAIMMetalRenderPipeline()

//    変換行列
    var mat:Matrix4x4 = .identity
    
    var determinedPoint:[Point] = [Point]()
    var tempLineData:Line?
    var lineData = [Line]()

//    GPU送信データ
    var lineBuffer : LineMesh = LineMesh()

    // 準備関数
    override func setup()
    {
        super.setup()
        // Metalを使うビューを作成してViewControllerに追加
        metal_view = CAIMMetalView( frame: pixelBounds )
        self.view.addSubview( metal_view! )

        let aspect = Float( metal_view!.pixelBounds.width / metal_view!.pixelBounds.height )

        // ピクセルプロジェクション行列バッファの作成(画面サイズに合わせる)
        mat = Matrix4x4.perspective(aspect: aspect, fieldOfViewY: 60.0, near: 0.01, far: 100.0)
        mat = Matrix4x4.pixelProjection(metal_view!.pixelBounds.size)

        // 円描画の準備
        setupMetalShader()
    }

    //用いるShaderの指定
    func setupMetalShader()
    {
        // パイプラインの作成
        linePipeline.make
        {
            // シェーダを指定
            $0.vertexShader = CAIMMetalShader("vertLine")
            //            $0.vertexShader = CAIMMetalShader( "vertRotate" )
            $0.fragmentShader = CAIMMetalShader( "fragStandard" )
            
        }
    }
    // Metalで実際に描画を指示する関数
    func render( encoder:MTLRenderCommandEncoder )
    {
        if(lineData.count > 0)
        {
            encoder.use( linePipeline )
            {
                // 頂点シェーダのバッファ1番に行列matをセット
                $0.setVertexBuffer( mat, index: 1 )
                // 円描画用の四角形データ群の頂点をバッファ0番にセットし描画を実行
                $0.drawShape( lineBuffer.lines, index: 0 )
            }
        }
    }
    //指の位置に一時的なLineを生成
    func genTempline()
    {
        if(tempLineData != nil)
        {
            lineData.remove(at: lineData.count - 1)
        }
        if(metal_view!.touchPixelPos.count >= 2)
        {
            let p1 = metal_view!.touchPixelPos[0]
            let p2 = metal_view!.touchPixelPos[1]
            let color = CAIMColor(0,0,0,1.0)
            tempLineData = VertexGenerator.genLine(pos1: p1, pos2: p2, color1: color, color2: color, nowFrame: 0)
        }

        else{
            tempLineData = nil
        }
    }

    //指を離した点でLineを決定する
    func determinedLine()
    {
        if(metal_view!.touchPixelPos.count > 1)
        {
            determinedPoint.removeAll()
        }
        if(metal_view!.releasePixelPos.count > 0)
        {
            for i in 0 ..< metal_view!.releasePixelPos.count
            {
                let p = metal_view!.releasePixelPos[i]
                let color = CAIMColor(0,0,0,1.0)
                let point = VertexGenerator.genPoint(pos: p, color: color)

                determinedPoint.append(point)
            }
        }

        if(determinedPoint.count >= 2)
        {
            let p1 = determinedPoint[0]
            let p2 = determinedPoint[1]
            let line = Line(p1: p1, p2: p2, frameCount: 0, wid: 3.0)

            lineData.append(line)
            determinedPoint.removeAll()
        }
    }

    
}
