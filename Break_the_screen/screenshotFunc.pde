import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.image.*;

// スクリーンショット関係の関数

// スクリーンショットの作成
// ほぼjavaの機能を使用
PImage screenshot(){
    try{
        // Robotの中にあるスクリーンショット機能(createScreenCapture())を使用
        Robot robot = new Robot();
        
        // createScreenCapture()の引数はキャプチャする範囲のrect
        // その為にまずスクリーンサイズを取得
        // getScreenSize()はメインディスプレイのサイズを返す
        // Dimensionクラスは、幅と高さを持つクラス
        Dimension screen_size = Toolkit.getDefaultToolkit().getScreenSize();

        // コンストラクタ Rectangle(Dimension) は、
        // 左上の座標を(0,0)、幅と高さをDimensionのRectangleを生成
        BufferedImage img = robot.createScreenCapture(new Rectangle(screen_size));

        // BufferedImageからPImageに変換
        PImage result = new PImage(img);
        
        return result;

    }catch(Exception e){
        println("スクリーンショットエラー");
        exit();
        return null;
    }
}
