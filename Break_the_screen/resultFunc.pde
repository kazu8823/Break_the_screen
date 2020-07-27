// リザルト画面

void result(){
    // サブウィンドウ用描写****************************
    back_pg.beginDraw();
    
    // スクショ画像（背景)
    back_pg.image(back_img, 0, 0);

    back_pg.endDraw();
    // サブウィンドウ用描写ここまで*********************

    textSize(35);
    text("Click shift key!!", 210, 250);
    text("SCORE:" + nf(score, 8), 10, 10);
    text("耐久時間:" + game_frame_count / 60, 10, 50);
    text("消したブロック数:" + block_cover_count, 10, 90);
}

// mode=5 の時にシフトキーがクリックされると呼び出し
void shift_click_in_result(){
    // メニュー画面へ遷移
    mode = 6;

    // メインウィンドウの非表示化
    surface.setVisible(false);
}