// 入力に対する処理など
// 基本的にはkeyFunc.pdeにある関数から呼び出される

// シフトキーが押された瞬間に呼び出される
void shift_click(){
    //println("シフトキーが押されました");
    switch(mode){
        case 1:     // メニュー画面なら
            shift_click_in_menu();
            break;
        
        case 3:     // ゲーム画面なら
            shift_click_in_game();
            break;

        case 5:     // リザルト画面なら
            shift_click_in_result();
            break;
    }
}

// 上矢印キーが押された瞬間に呼び出される
void up_click(){
    //println("上矢印が押されました");
}

// 下矢印キーが押された瞬間に呼び出される
void down_click(){
    //println("下矢印が押されました");
}

// 左矢印キーが押された瞬間に呼び出される
void left_click(){
    //println("左矢印が押されました");
}

// 右矢印キーが押された瞬間に呼び出される
void right_click(){
    //println("右矢印が押されました");
}

