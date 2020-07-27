// ブロック(崩れた画面)

class Block{
    // 画像データ
    PImage img;

    // 現在位置
    int px, py;

    // 本来の位置
    int before_px, before_py;

    // ブロックの大きさ(基本縦横比1:1)
    int b_width, b_height;

    // 回転した場合の半径の長さ
    int b_r;

    // 現在の回転角 (使わないかも)
    float now_angle = 0;

    // 無敵時間
    // 出現してすぐにぶつかっても平気にするため
    int start_count = 0;

    // 動き方
    int move_mode = 0;
    // 0: 消去処理
    // 1: 直線移動
    // 2: プレイヤー方向にゆっくり移動
    // 3: 画面端沿いにぴょんぴょんする
    // 4: プレイヤー方向に急いで移動(止まる→急加速を繰り返す)


    // 動き方によって違うデータ************************************
    
    // mode=0 用
    int fade_frame_count = 64;

    // mode=1 用
    // 進むピクセル数
    int dx, dy;

    // mode=2 用
    // スピード(定数)
    int MODE2_SPEED = 2;

    // 動き方によって違うデータここまで*****************************


    // コンストラクタ
    // 引数は(初期位置X, 初期位置Y, 幅, 高さ, 動き方)
    Block(int px, int py, int b_width, int b_height, int move_mode){
        this.px = before_px = px;
        this.py = before_py = py;
        this.b_width = b_width;
        this.b_height = b_height;
        this.move_mode = move_mode;

        
        // 画像データの作成
        img = createImage(b_width, b_height, RGB);

        img.loadPixels();
        for(int i = 0 ; i < b_width ; i++){
            for(int j = 0 ; j < b_height ; j++){
                img.pixels[i * b_height + j] = back_img.pixels[(i + py) * displayWidth + (j + px)];
            }
        }
        img.updatePixels();

        // PImageの作成
        this.img = img;
        
        // 半径の計算
        b_r = (int)sqrt(px * px + py * py) / 2;

        // モードによる初期値設定
        switch(move_mode){
            case 1:     // 直線移動
                // dx,dyの初期値設定
                // ランダム方向に等速運動
                float speed = random(5) + 5.0;
                float angle = random(2.0 * PI);

                dx = (int)(speed * cos(angle));
                dy = (int)(speed * sin(angle));
                
                break;
        }
    }


    // ブロックの移動
    // 毎フレーム呼び出す
    // もしメインウィンドウにぶつかった場合1を
    // メインウィンドウが出現位置にかぶった場合2を
    // ブロックを消すタイミングなら3を
    // それ以外は0を返す
    int move(){
        switch(move_mode){
            case 0:     // 消去処理
                fade_frame_count--;
                if(fade_frame_count <= 0){
                    return 3;
                }
                break;

            case 1:     // 直線移動
                // 移動処理
                px += dx;
                py += dy;

                // 壁との衝突判定
                if(px <= 0){
                    dx = max(-dx, dx);
                }
                if(px + b_width >= displayWidth){
                    dx = min(-dx, dx);
                }
                if(py <= 0){
                    dy = max(-dy, dy);
                }
                if(py + b_height >= displayHeight){
                    dy = min(-dy, dy);
                }

                break;

            case 2:     // プレイヤー方向にゆっくり移動
                // 中心座標の計算
                int w_center_x = win_px - win_cor_x + (width / 2);
                int w_center_y = win_py - win_cor_y + (height / 2);
                int b_center_x = px + (b_width / 2);
                int b_center_y = py + (b_height / 2);

                // 移動は基本斜め
                if(w_center_x < b_center_x){
                    px -= MODE2_SPEED;
                }else if(w_center_x > b_center_x){
                    px += MODE2_SPEED;
                }
                if(w_center_y < b_center_y){
                    py -= MODE2_SPEED;
                }else if(w_center_y > b_center_y){
                    py += MODE2_SPEED;
                }


                break;

            case 3:     // 画面端沿いにぴょんぴょんする 未実装

                break;

            case 4:     // プレイヤー方向に急いで移動　未実装

                break;

        }
        
        if(move_mode == 0){
            // フェードアウト中なら省略
            return 0;
        }

        // ウィンドウと元の場所の衝突判定
        if(win_px - win_cor_x <= before_px && win_px - win_cor_x + width >= before_px + b_width 
         && win_py - win_cor_y <= before_py && win_py - win_cor_y + height >= before_py + b_height){
            move_mode = 0;
            return 2;
        }

        start_count++;
        if(start_count <= 120){
            // 出現から2秒間は当たり判定が存在しない
            return 0;
        }

        // ウィンドウとの衝突判定(無回転時)
        if(win_px - win_cor_x + width > px && win_px - win_cor_x < px + b_width && win_py - win_cor_y + height > py && win_py - win_cor_y < py + b_height){
            return 1;
        }

        

        // 特に何もなし
        return 0;
    }

    // 描画処理　背景側
    void draw1(){
        if(move_mode == 0){
            // フェードアウト
            back_pg.image(img, before_px, before_py);
            back_pg.fill(0, fade_frame_count * 4);
            back_pg.noStroke();
            back_pg.rect(before_px, before_py, b_width, b_height);
        }else{
            // 抜け落ちた部分の描写
            back_pg.fill(0, constrain(start_count * 2, 0, 255));
            back_pg.noStroke();
            back_pg.rect(before_px, before_py, b_width, b_height);
        }
    }

    // 描画処理　ブロック側
    void draw2(){
        // 透明度の設定
        if(move_mode == 0){
            back_pg.tint(255, fade_frame_count * 4);
        }else{
            back_pg.tint(255, constrain(start_count * 2, 0, 255));
        }

        // ブロック関係の描写
        back_pg.image(img, px, py);
        back_pg.noFill();
        if(start_count <= 120 && move_mode != 0){
            back_pg.stroke(255, 0, 0, constrain(start_count * 2, 0, 255));
        }else{
            back_pg.stroke(255, 0, 0, constrain(fade_frame_count * 4, 0, 200));
        }
        back_pg.strokeWeight(4);
        back_pg.rect(px + 2, py + 2, b_width - 4, b_height - 4);

        // 透明度の設定リセット
        back_pg.noTint();
        
    }

}