// 画面遷移中のアニメーション関係

// 共通で使うフレームカウント用変数
int anime_frame_count = 0;


// メニュー画面からゲーム画面へ
// 最初の約1秒間はフェードアウト
// 次の約1秒間でフェードイン
void menu2game(){
    // サブウィンドウ用描写****************************
    back_pg.beginDraw();
    
    // スクショ画像（背景)
    back_pg.image(back_img, 0, 0);


    back_pg.tint(255, anime_frame_count * 4);

    // スコア描写枠
    back_pg.image(score_frame, (displayWidth - 400) / 2, 0);

    // スコア描画
    back_pg.fill(255, anime_frame_count * 4);
    back_pg.textSize(50);
    back_pg.text(nf(score, 8), (displayWidth - 400) / 2 + 40, 2);

    // ライフ描画
    back_pg.textSize(40);
    back_pg.fill(0, anime_frame_count * 4);
    back_pg.text(life, (displayWidth - 400) / 2 + 335, 7);

    back_pg.noTint();

    back_pg.endDraw();
    // サブウィンドウ用描写ここまで*********************


    if(anime_frame_count < 64){
        // メニュー画面が徐々にフェードアウトしていく
        textSize(35);
        text("Click shift key!!", 210, 250);
        fill(0, anime_frame_count * 4);
        rect(0, 0, width, height);

    }else if(anime_frame_count < 128){
        // ゲーム画面にフェードインかつウィンドウサイズの変更
        if(((anime_frame_count - 64) >> 3) % 2 == 0){
            // 画面サイズ300x300
            surface.setSize(300, 300);
        }else{
            // 画面サイズ200x200
            surface.setSize(200, 200);
        }
        win_px = (displayWidth - width) / 2;
        win_py = (displayHeight - height) / 2;
        surface.setLocation(win_px, win_py);

        image(back_pg, win_cor_x - win_frame.getX(), win_cor_y - win_frame.getY());
        fill(0, (128 - anime_frame_count) * 4);
        rect(0, 0, height, width);

    }else{
        // アニメーションの終了
        // ゲーム画面へ
        image(back_pg, win_cor_x - win_frame.getX(), win_cor_y - win_frame.getY());
        anime_frame_count = 0;
        mode = 3;

        // ゲーム関係の初期化
        add_block_cnt = 0;
        now_situ = 0;
        game_frame_count = 0;
        block_count = 0;
        block_cover_count = 0;

        // ブロックの生成
        block_create();

        return;
    }
    
    anime_frame_count++;
}

// ゲーム画面からリザルト画面へ
// 1:最初の1秒でメインウィンドウを点滅、その後消す
// 2:次の1秒で背景をブラックアウト
// 3:次の2秒でゲームオーバー表示
// 4:次の1秒で背景を戻す
// 最後にメインウィンドウを表示し、リザルトに移行

// 現在のステップの変数
int g2r_step = 1;

void game2result(){

    if(anime_frame_count < 64){
        g2r_step = 1;
    }else if(anime_frame_count < 128){
        g2r_step = 2;
    }else if(anime_frame_count < 256){
        g2r_step = 3;
    }else{
        g2r_step = 4;
    }

    // サブウィンドウ用描写****************************
    back_pg.beginDraw();
    
    // スクショ画像（背景)
    back_pg.image(back_img, 0, 0);

    if(g2r_step <= 2){
        // スコア描写枠
        back_pg.image(score_frame, (displayWidth - 400) / 2, 0);

        // スコア描画
        back_pg.fill(255);
        back_pg.textSize(50);
        back_pg.text(nf(score, 8), (displayWidth - 400) / 2 + 40, 2);

        // ライフ描画
        back_pg.textSize(40);
        back_pg.fill(0);
        back_pg.text(life, (displayWidth - 400) / 2 + 335, 7);

    }

    if(g2r_step == 2){
        // フェードアウト
        back_pg.fill(0, (anime_frame_count - 64) * 4);
        back_pg.noStroke();
        back_pg.rect(0, 0, displayWidth, displayHeight);

    }else if(g2r_step == 3){
        // 背景
        back_pg.fill(0, 255);
        back_pg.noStroke();
        back_pg.rect(0, 0, displayWidth, displayHeight);

        // ゲームオーバー表示
        back_pg.textSize(200);
        if(anime_frame_count < 160){
            back_pg.fill(255, (anime_frame_count - 128) * 8);
            back_pg.text("GAME OVER", (displayWidth - back_pg.textWidth("GAME OVER")) / 2, (displayHeight - 200) / 2 - (160 - anime_frame_count) * 4);
        }else if(anime_frame_count < 224){
            back_pg.fill(255);
            back_pg.text("GAME OVER", (displayWidth - back_pg.textWidth("GAME OVER")) / 2, (displayHeight - 200) / 2);
        }else{
            back_pg.fill(255, (255 - anime_frame_count) * 8);
            back_pg.text("GAME OVER", (displayWidth - back_pg.textWidth("GAME OVER")) / 2, (displayHeight - 200) / 2 + (anime_frame_count - 224) * 4);
        }

    }else if(g2r_step == 4){
        // フェードイン
        back_pg.fill(0, constrain((320 - anime_frame_count), 0, 63) * 4);
        back_pg.noStroke();
        back_pg.rect(0, 0, displayWidth, displayHeight);
    }

    
    back_pg.endDraw();
    // サブウィンドウ用描写ここまで*********************

    switch(g2r_step){
        case 1:
            // メインウィンドウの背景
            image(back_pg, win_cor_x - win_frame.getX(), win_cor_y - win_frame.getY());

            // 外枠の描写
            noFill();
            stroke(10, 255, 10, 200);
            strokeWeight(1);
            rect(5, 5, width - 10, height - 10);

            // ウィンドウの点滅
            if((anime_frame_count >> 4) % 2 == 1){
                surface.setVisible(false);
            }else{
                surface.setVisible(true);
            }
            if(anime_frame_count >= 63){
                // case2へ切り替わる瞬間
                
                // リザルト画面の大きさに設定
                win_width = SIZE_WIDTH;
                win_height = SIZE_HEIGHT;
                surface.setSize(win_width, win_height);
                win_px = (displayWidth - width) / 2;
                win_py = (displayHeight - height) / 2;
                surface.setLocation(win_px, win_py);
            }
            break;

        case 2:
        case 3:

            break;

        case 4:
            if(anime_frame_count >= 320){
                // リザルト画面に移行
                mode = 5;
                anime_frame_count = 0;
                g2r_step = 1;
                surface.setVisible(true);
            }
            break;
    }

    anime_frame_count++;

}

// リザルト画面からメニュー画面へ
// メインウィンドウが、0.5秒間消えその後復活
void result2menu(){
    // サブウィンドウ用描写****************************
    back_pg.beginDraw();
    
    // スクショ画像（背景)
    back_pg.image(back_img, 0, 0);


    back_pg.endDraw();
    // サブウィンドウ用描写ここまで*********************

    if(anime_frame_count >= 30){
        anime_frame_count = 0;
        mode = 1;
        surface.setVisible(true);
    }

    anime_frame_count++;
}

