// ゲーム画面

// 現在の状況
int now_situ = 0;
// 0: 特に無し、普通に動ける 
// 1: ダメージを受けて無敵時間中

// 無敵時間
int free_frame_count = 60;

// ブロック追加タイミングをはかるカウンタ
// リセット値をblock_countによって増やしていくことによって、
// 時間経過で難易度を上昇させる
int add_block_cnt = 0;

// ライフ最大値
final int LIFE_MAX = 5;

// ライフ
int life = LIFE_MAX;

// スコア
// 加算式　
// 毎フレーム、画面上にあるブロックの個数=nとしたとき n^2 点加算
// ブロックを消すごとにブロックの幅のピクセル数x10点加算
int score = 0;

// 経過フレーム
int game_frame_count = 0;

// 累計ブロック数
int block_count = 0;

// 戻したブロック数
int block_cover_count = 0;

// ブロック(崩れたディスプレイ)
ArrayList<Block> blocks;


void game(){
    
    //ブロックごとの処理
    for(int i = 0 ; i < blocks.size() ; i++){
        int temp = blocks.get(i).move();
        if(temp == 1){
            // ブロックと衝突した

            // ウィンドウサイズの初期化
            // 中心を原点として縮小
            win_width = width;
            win_height = height;
            int tempx = win_width - 200;
            tempx /= 2;
            win_px += tempx;
            int tempy = win_height - 200;
            tempy /= 2;
            win_py += tempy;

            win_width = win_height = 200;

            surface.setSize(win_width, win_height);
            in_screen();

            // ブロックの消去
            blocks.clear();
            
            // 無敵時間の開始
            free_frame_count = 60;
            now_situ = 1;

            // ブロック追加カウントの初期化
            add_block_cnt = 0;

            // ライフの減少
            life--;
            if(life == 0){
                // ゲームオーバー処理
                mode = 4;
                return;
            }

        }else if(temp == 2){
            // ブロックの元の場所に覆いかぶさった
            // ウィンドウサイズの初期化
            // 中心を原点として縮小
            int tempx = win_width - 200;
            tempx /= 2;
            win_px += tempx;
            int tempy = win_height - 200;
            tempy /= 2;
            win_py += tempy;

            win_width = win_height = 200;

            surface.setSize(win_width, win_height);
            in_screen();

            // スコア加算
            score += blocks.get(i).b_width * 10;

            block_cover_count++;

        }else if(temp == 3){
            blocks.remove(i);
        }
    }


    if(now_situ == 0){
        // ブロック追加カウントダウン
        add_block_cnt++;

        // ブロック追加処理
        if(add_block_cnt >= 300){
            add_block_cnt = constrain(block_count * 3, 0, 200);
            block_create();
        }

        // ブロックが一つもなくなったら追加
        if(blocks.size() == 0){
            block_create();
            add_block_cnt = constrain(block_count * 3, 0, 200);
        }
    }

    // スコア計算
    score += blocks.size() * blocks.size(); 

    
    // サブウィンドウ用描写****************************
    //println("PG描写スタート");
    back_pg.beginDraw();
    
    // スクショ画像（背景)
    back_pg.image(back_img, 0, 0);

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

    // 背景の描写
    for(int i = 0 ; i < blocks.size() ; i++){
        blocks.get(i).draw1();
    }
    // ブロックの描写
    for(int i = 0 ; i < blocks.size() ; i++){
        blocks.get(i).draw2();
    }
    

    back_pg.endDraw();
    //println("PG描写終了");
    // サブウィンドウ用描写ここまで*********************


    // 移動処理
    if(now_situ == 0){
        int dx = 0;
        int dy = 0;

        // キー入力のチェック
        if(key_up){
            dy--;
        }
        if(key_down){
            dy++;
        }
        if(key_left){
            dx--;
        }
        if(key_right){
            dx++;
        }

        // スピード変更
        int speed = ((height - 200) / 18) + 5;

        win_px += dx * speed;
        win_py += dy * speed;
    }else{
        // 無敵時間中
        free_frame_count--;
        if(free_frame_count <= 0){
            // 無敵時間の終了
            free_frame_count = 60;
            block_create();
            now_situ = 0;
        }else{
            // 無敵時間中の処理
            if((free_frame_count / 10) % 2 == 1){
                surface.setVisible(false);
            }else{
                surface.setVisible(true);
            }
        }
    }
    // 画面位置をマウスで変更できなくする
    in_screen();

    // メインウィンドウの背景
    image(back_pg, win_cor_x - win_frame.getX(), win_cor_y - win_frame.getY());

    // 外枠の描写
    noFill();
    stroke(10, 255, 10, 200);
    strokeWeight(life);
    rect(5, 5, width - 10, height - 10);

    // 経過時間のカウント
    game_frame_count++;
}


// ブロックの生成
void block_create(){
    int x, y;
    int b_w, b_h;
    int move_mode;

    b_w = b_h = (int)random(50, 200);
    x = (int)random(0, displayWidth - b_w);
    y = (int)random(100, displayHeight - b_h);


    move_mode = (int)random(1,3);

    // ブロックの追加
    blocks.add(new Block(x, y, b_w, b_h, move_mode));
}

// mode=3 の時にシフトキーがクリックされると呼び出し
void shift_click_in_game(){
    // ウィンドウサイズを大きくする処理
    win_height += 6;
    win_width += 6;
    if(win_height >= 380){
        win_height = 380;
        win_width = 380;
    }else{
        // 拡大しても中心を維持
        win_px -= 3;
        win_py -= 3;
    }
    surface.setSize(win_width, win_height);
    in_screen();
}

// 画面外にウィンドウが出ないように移動
void in_screen(){
    // 画面左端
    if(win_px - win_cor_x <= 0){
        win_px = win_cor_x;
    }
    // 画面右端
    if(win_px - win_cor_x + width >= displayWidth){
        win_px = displayWidth + win_cor_x - width;
    }
    // 画面上端
    if(win_py - win_cor_y <= 0){
        win_py = win_cor_y;
    }
    // 画面下端
    if(win_py - win_cor_y + height >= displayHeight){
        win_py = displayHeight + win_cor_y - height;
    }

    surface.setLocation(win_px, win_py);
}