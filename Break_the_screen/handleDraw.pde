// handleDraw()のオーバーライド
// 元のソース:https://github.com/processing/processing/blob/master/core/src/processing/core/PApplet.java#L2373
// メインウィンドウの描写後にサブウィンドウ側の描写を行うためオーバーライドして書き換えている

public void handleDraw() {

    if (g == null) return;
    if (!looping && !redraw) return;

    if (insideDraw) {
        System.err.println("handleDraw() called before finishing");
        System.exit(1);
    }

    insideDraw = true;
    g.beginDraw();
    if (recorder != null) {
        recorder.beginDraw();
    }

    long now = System.nanoTime();

    if (frameCount == 0) {
        setup();
        back_window.setup();    // 追加、サブウィンドウ側のhandleDraw()を書き換えているためここから呼び出し

    } else {  
        {
            // Get the frame time of the last frame
            double frameTimeSecs = (now - frameRateLastNanos) / 1e9;
            // Convert average frames per second to average frame time
            double avgFrameTimeSecs = 1.0 / frameRate;
            // Calculate exponential moving average of frame time
            final double alpha = 0.05;
            avgFrameTimeSecs = (1.0 - alpha) * avgFrameTimeSecs + alpha * frameTimeSecs;
            // Convert frame time back to frames per second
            frameRate = (float) (1.0 / avgFrameTimeSecs);
        }

        if (frameCount != 0) {
            handleMethods("pre");
        }

        // use dmouseX/Y as previous mouse pos, since this is the
        // last position the mouse was in during the previous draw.
        pmouseX = dmouseX;
        pmouseY = dmouseY;

        //println("Calling draw()");
        draw();
        //println("Done calling draw()");

        // dmouseX/Y is updated only once per frame (unlike emouseX/Y)
        dmouseX = mouseX;
        dmouseY = mouseY;

        // these are called *after* loop so that valid
        // drawing commands can be run inside them. it can't
        // be before, since a call to background() would wipe
        // out anything that had been drawn so far.
        dequeueEvents();

        handleMethods("draw");

        redraw = false;  // unset 'redraw' flag in case it was set
        // (only do this once draw() has run, not just setup())
    }
    g.endDraw();

    // if (pquality != g.smooth) {
    //     surface.setSmooth(g.smooth);
    // }

    if (recorder != null) {
        recorder.endDraw();
    }
    insideDraw = false;

    if (frameCount != 0) {
        handleMethods("post");
    }

    frameRateLastNanos = now;
    frameCount++;


    // ここからが変更点*****************************
    // サブウィンドウ側のdrawを呼び出す
    back_window.g.beginDraw();
    back_window.draw();
    back_window.g.endDraw();

    // ここまでが変更点*****************************
}