// キーボード系の処理

// 使うキーは矢印キー4つ、シフトキーのみ
// これらはすべてkeyCodeを用いて取得する

// そのキーが押されているかどうかのフラグ
boolean key_up = false, key_down = false, key_right = false, key_left = false, key_shift = false;

// keyPressedを集約するための関数
// メインウィンドウからもサブウィンドウからもここを呼び出すようにする
// また、これと同時に押し始めかどうかの判定もする
public void _keyPressed(int keyCode){
    switch(keyCode){
        case UP:        //上矢印キー
            if(!key_up){
                //キーが押された瞬間なら
                up_click();
            }
            key_up = true;
            break;
            
        case DOWN:      //下矢印キー
            if(!key_down){
                //キーが押された瞬間なら
                down_click();
            }
            key_down = true;
            break;
            
        case LEFT:      //左矢印キー
            if(!key_left){
                //キーが押された瞬間なら
                left_click();
            }
            key_left = true;
            break;
            
        case RIGHT:     //右矢印キー
            if(!key_right){
                //キーが押された瞬間なら
                right_click();
            }
            key_right = true;
            break;
            
        case SHIFT:     //シフトキー
            if(!key_shift){
                //キーが押された瞬間なら
                shift_click();
            }
            key_shift = true;
            break;
            
        default :
            //何もしない    
            break;	
    }
}


// keyReleasedを集約するための関数
// メインウィンドウからもサブウィンドウからもここを呼び出すようにする
public void _keyReleased(int keyCode) {
    switch(keyCode){
        case UP:        //上矢印キー
            key_up = false;
            break;
            
        case DOWN:      //下矢印キー
            key_down = false;
            break;
            
        case LEFT:      //左矢印キー
            key_left = false;
            break;
            
        case RIGHT:     //右矢印キー
            key_right = false;
            break;
            
        case SHIFT:     //シフトキー
            key_shift = false;
            break;
            
        default :
            //何もしない    
            break;	
    }
}