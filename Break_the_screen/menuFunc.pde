// メニュー画面

void menu(){
    // サブウィンドウ用描写****************************
    back_pg.beginDraw();
    
    // スクショ画像（背景)
    back_pg.image(back_img, 0, 0);


    back_pg.endDraw();
    // サブウィンドウ用描写ここまで*********************

    textSize(50);
    text("画面崩壊阻止ゲーム", (500 - textWidth("画面崩壊阻止ゲーム")) / 2, 20);

    textSize(35);
    text("Click shift key!!", 210, 250);
}

// mode=1 の時にシフトキーがクリックされると呼び出し
void shift_click_in_menu(){
    // ゲーム画面へ遷移
    mode = 2;

    // ライフ設定
    life = LIFE_MAX;

    // スコア初期化
    score = 0;
}