package kha.flash;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import kha.graphics.TextureFormat;

class ShaderPainter extends kha.ShaderPainter {
	private var videoBitmap: BitmapData;
	private var videoImage: Image;
	
	public function new(width: Int, height: Int) {
		super(width, height);
		videoBitmap = new BitmapData(width, height, true, 0xffffff);
		videoImage = new Image(width, height, TextureFormat.RGBA32);
	}

	override public function drawVideo(video: kha.Video, x: Float, y: Float, width: Float, height: Float): Void {
		/*flushBuffers();
		
		var stageVideo = new flash.media.Video(Std.int(width), Std.int(height));
		stageVideo.attachNetStream(cast(video, Video).stream);
				
		textBitmap.fillRect(new Rectangle(0, 0, textBitmap.width, textBitmap.height), 0xffffff);
		textBitmap.draw(stageVideo);
		textTexture.uploadFromBitmapData(textBitmap, 0);
		
		var dx = x;
		var dy = y;
		var dw = textField.width;
		var dh = textField.height;
		var u1 = 0.0;
		var u2 = 1.0;
		var v1 = 0.0;
		var v2 = 1.0;
		var offset = 0;
		
		vertices[offset +  0] = tx + dx;      vertices[offset +  1] = ty + dy;      vertices[offset +  2] = 1; vertices[offset +  3] = u1; vertices[offset +  4] = v1;
		vertices[offset +  5] = tx + dx + dw; vertices[offset +  6] = ty + dy;      vertices[offset +  7] = 1; vertices[offset +  8] = u2; vertices[offset +  9] = v1;
		vertices[offset + 10] = tx + dx;      vertices[offset + 11] = ty + dy + dh; vertices[offset + 12] = 1; vertices[offset + 13] = u1; vertices[offset + 14] = v2;
		vertices[offset + 15] = tx + dx + dw; vertices[offset + 16] = ty + dy + dh; vertices[offset + 17] = 1; vertices[offset + 18] = u2; vertices[offset + 19] = v2;
		
		context.setTextureAt(0, textTexture);
		vertexBuffer.uploadFromVector(vertices, 0, 4 * 1);
		context.drawTriangles(indexBuffer, 0, 2 * 1);
		*/
		
		var stageVideo = new flash.media.Video(Std.int(width), Std.int(height));
		stageVideo.attachNetStream(cast(video, Video).stream);
		videoBitmap.fillRect(new Rectangle(0, 0, width, height), 0xffffff);
		videoBitmap.draw(stageVideo);
		videoImage.uploadtBitmap(videoBitmap);
		drawImage2(videoImage, 0, 0, width, height, x, y, width, height);
	}
}
