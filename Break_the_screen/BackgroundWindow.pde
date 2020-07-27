// 背景用の画像ウィンドウ
// 別ウィンドウの為PAppletを継承したクラス
// メインウィンドウ側からPGraphicsで受け渡し、描写する
public class BackgroundWindow extends PApplet{

    // メインウィンドウ側のPApplet
    // メインウィンドウ側のPAppletは何もせずに呼び出せるのでいらないかもしれない
    PApplet main_window;


    void settings(){
        // フルスクリーンに
        fullScreen();
    }

    void setup() {
        // 一時的に非表示に
        surface.setVisible(false);

        // テキストを左上基準に
        textAlign(LEFT, TOP);

    }

    // 本来はthis.handleDraw()から呼ばれるが、
    // メインウィンドウのPApplet.handleDraw()から呼び出す
    void draw() {
        // 一度読み書きしないと使えないっぽい
        back_pg.beginDraw();
        back_pg.endDraw();

        // 背景
        image(back_pg, 0, 0);

    }

    // これら二つはもしサブウィンドウをアクティブにしてしまった際でも
    // 入力ができるようにするために書いている
    void keyPressed() {
        // キー入力関係の関数呼び出し(keyFunc.pde)
        _keyPressed(keyCode);
    }

    void keyReleased() {
        // キー入力関係の関数呼び出し(keyFunc.pde)
        _keyReleased(keyCode);
    }


    // handleDrawの無効化
    void handleDraw(){
        // メインウィンドウ→サブウィンドウの順番で描写させる為に
        // draw()を呼び出すhandleDraw()をオーバーライドし、
        // サブウィンドウ側では無効化
        // メインウィンドウ側から直接draw()を呼び出す形に変更

        // キーイベントを有効にするために必要
        dequeueEvents();
    }
}
