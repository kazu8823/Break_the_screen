import java.awt.Frame;
import processing.awt.PSurfaceAWT;

// このゲームはウィンドウを二つ出現させます
// ・背景用のフルスクリーン(BackgroundWindow.pde)
// ・操作するウィンドウ(このファイル)
// そして、メインの操作するウィンドウは常に前面に表示させます。

// ゲーム仕様
// 矢印キーでウィンドウを移動
// シフトでウィンドウを大きくする(押した回数に応じて)
// 抜け落ちた画面の場所を囲むと、その画面は元に戻りウィンドウも初期サイズに戻る


// 画面遷移関係
int mode = 0;
//0: 起動直後　1フレーム目にメインウィンドウ、2フレーム目にサブウィンドウを表示　その後1へ
//1: メニュー画面　シフトキーを押すと2へ
//2: メニュー画面からゲーム画面へのアニメーション　時間経過で3へ
//3: ゲーム画面　ゲームオーバー時に4へ
//4: ゲーム画面からリザルト画面へのアニメーション　時間経過で5へ
//5: リザルト画面　シフトキーを押すと6へ
//6: リザルト画面からメニュー画面へのアニメーション　時間経過で1へ


// サブウィンドウ(背景)用の変数など********************************

// サブウィンドウ
BackgroundWindow back_window;

// フルスクリーン背景用の画像
// アプリ起動前に撮る
PImage back_img;

// サブウィンドウに表示する画像(PGraphics)
// draw()が呼び出されたタイミングで、サブウィンドウからこれにアクセスする
PGraphics back_pg;

// サブウィンドウ用ここまで****************************************


// メインウィンドウの大きさ(メニュー・リザルト画面)
final int SIZE_WIDTH = 500;
final int SIZE_HEIGHT = 300;

// 現在のウィンドウの座標
int win_px, win_py;

// ゲーム中のウィンドウの大きさ
int win_height = 200, win_width = 200;

// ウィンドウの場所を取得するため
Frame win_frame;

// win_frameのずれを補正する
// image(back_pg, win_cor_x - win_frame.getX(), win_cor_y - win_frame.getY());
// のように使う
int win_cor_x = -3;
int win_cor_y = -26;

// フォントの設定
PFont font;

// スコア表示枠画像
PImage score_frame;


// 別ウィンドウを使用しているとsetup内にsize()を書けない仕様の為
// settings()を使用
void settings(){
    // 背景の取得
    back_img = screenshot();

    // サイズの変更
    size(SIZE_WIDTH, SIZE_HEIGHT);

}

void setup(){
    // 一時的に非表示に
    surface.setVisible(false);

    // フルスクリーンの上に表示するために、常に前面に表示
    surface.setAlwaysOnTop(true);


    // ウィンドウ位置の初期設定
    // 基本的に中心に表示
    win_px = (displayWidth - width) / 2;
    win_py = (displayHeight - height) / 2;
    surface.setLocation(win_px, win_py);

    // ウィンドウ位置を取得するための設定
    PSurfaceAWT.SmoothCanvas canvas = (PSurfaceAWT.SmoothCanvas)surface.getNative();
    win_frame = canvas.getFrame();


    // サブウィンドウ生成******************************

    // ウィンドウの初期化の際に使用するパラメーター
    String[] args = {"SecondApplet"};

    // サブウィンドウを開く
    back_window = new BackgroundWindow();
    PApplet.runSketch(args, back_window);
    // サブウィンドウ側にメインのPAppletを渡す
    back_window.main_window = this;

    // サブウィンドウ生成ここまで***********************


    // ブロック関係の初期化
    blocks = new ArrayList<Block>();


    // サブウィンドウ向けPGraphicsの初期化
    back_pg = createGraphics(displayWidth, displayHeight);

    // サブウィンドウ向けPGraphicsの設定
    back_pg.beginDraw();
    back_pg.textAlign(LEFT, TOP);   // テキストを左上基準に
    back_pg.endDraw();

    // テキストを左上基準に(メインウィンドウ側の設定)
    textAlign(LEFT, TOP);

    //フォントの設定
    font = createFont("Meiryo UI", 80);
    textFont(font, 80);

    // フレームレート設定
    frameRate(60);

    // 画像の読み込み
    score_frame = loadImage("score_frame_with_heart_400.png");
}

void draw(){
    // PGraphics操作用のひな型
    /* それぞれでこれを改変する 
    // サブウィンドウ用描写****************************
    back_pg.beginDraw();
    
    // スクショ画像（背景)
    back_pg.image(back_img, 0, 0);


    back_pg.endDraw();
    // サブウィンドウ用描写ここまで*********************
    */

    background(0);
    fill(255);
    noStroke();

    switch(mode){
        case 0:     // 開始直後
            startup();
            break;

        case 1:     // メニュー
            menu();
            break;

        case 2:     // メニュー→ゲーム
            menu2game();
            break;

        case 3:     // ゲーム
            game();
            break;

        case 4:     // ゲーム→リザルト
            game2result();
            break;

        case 5:     // リザルト
            result();
            break;

        case 6:     // リザルト→メニュー
            result2menu();
            break;

        default:
            println("modeの値がおかしいです mode=" + mode);
            exit();    
            break;	

    }   
    
    // draw()終了後、サブウィンドウのdraw()が呼ばれる
}


void keyPressed() {
    // キー入力関係の関数呼び出し(keyFunc.pde)
    _keyPressed(keyCode);
}

void keyReleased() {
    // キー入力関係の関数呼び出し(keyFunc.pde)
    _keyReleased(keyCode);
}

