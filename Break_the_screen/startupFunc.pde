// 起動直後の処理

// フレームカウント用
int start_frame_count = 0;

// 起動後1フレーム目はメインウィンドウの表示
// 2フレーム目は背景のサブウィンドウ(フルスクリーン)の表示

void startup(){

    // サブウィンドウ用描写****************************
    back_pg.beginDraw();
    
    // スクショ画像（背景)
    back_pg.image(back_img, 0, 0);


    back_pg.endDraw();
    // サブウィンドウ用描写ここまで*********************

    if(start_frame_count == 0){
        //　メインウィンドウの表示
        surface.setVisible(true);
    }else{
        // サブウィンドウの表示
        PSurface srf = back_window.getSurface();
        srf.setVisible(true);
        mode = 1;
    }

    start_frame_count++;
}