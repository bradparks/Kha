package kha;

//
// VirtualDPad
//
// The VirtualDPad (virtual direction pad) is for systems which do not have
// normal dpad/buttons. The virtual dpad is displayed on the screen and can
// be controlled by touch or mouse controls.
//

//
// How to use:
//
// - Create a new VirtualDPad.
// - Call mouse handlers (mouseDown(), mouseUp(), mouseMove()), when they are called in your Game-class.
// - Use the left, right, up, down variables of the VirtualDPad to determine which direction the user presses.
// - Override the render()-function to make a beautiful virtual dpad.
// - If your VirtualDPad has another shape than a simple rectangle, override the checkMouseCollision()-function.
//   You might also want to override isMouseWithinMoveArea(), isMouseWithinDeadAreaX() and isMouseWithinDeadAreaY().
// - If the interaction should be canceled, for example if your game or a level in your game restarts, or if
//   the virtual dpad loses focus, because a window has been opened, or in any similar case, call reset().
//
// Caution:
// - Take care that nothing weird happens when the user presses on both real dpad/button or analog stick,
//   and virtual dpad at the same time. Because this can happen on systems that have both. You can use
//   user_is_interacting to handle this.
//
// Look into the VirtualDPadDemo to see how the VirtualDPad can be used.
//

class VirtualDPad {
	// Direction that the user is pressing:
	public var left : Bool;
	public var right: Bool;
	public var up   : Bool;
	public var down : Bool;
	
	// To check if the user is currently using the virtual dpad at all:
	public var user_is_interacting: Bool;
		// Indicates that the user is interacting with the virtual dpad, because he clicked/touched it.
		// The interaction is continued until the user releases the mouse button or stops touching. It
		// is continued even while the mouse/touch position is outside of the virtual dpad.
	
	// Position and sizes:
	public var x        : Int;
	public var y        : Int;
	public var size     : Int;
	public var dead_area: Int; // No reaction inside  the "dead-area"
	public var move_area: Int; // No reaction outside the "move-area"
	
	//
	// Constructor
	//
	// x, y     : Position on screen in pixels
	// size     : Size in pixels (used for both width and height)
	// dead_area: Within this area in the center no direction is pressed
	// move_area: Outside of this area no direction is pressed
	//
	public function new(x: Int, y: Int, size: Int, dead_area: Int, move_area: Int) {
		this.x         = x;
		this.y         = y;
		this.size      = size;
		this.dead_area = dead_area;
		this.move_area = move_area;
		
		resetInteraction();
	}
	
	//
	// reset()
	//
	// If the interaction should be canceled, for example if your game or a level in your game restarts,
	// or if the dpad loses focus, because a window has been opened, or in any similar case, call reset().
	//
	public function reset() {
		resetInteraction();
	}
	
	// Private
	private function resetInteraction() {
		left  = false;
		right = false;
		up    = false;
		down  = false;
		user_is_interacting = false;
	}
	
	// Private
	private function updateDirection(mouse_x: Int, mouse_y: Int) {
		left  = false;
		right = false;
		up    = false;
		down  = false;
		if (user_is_interacting) {
			// Determine direction to that is pressed.
			// No direction inside the "dead-area" or outside the "move-area".
			if (isMouseWithinMoveArea(mouse_x, mouse_y)) {
				// Left or right, depending on the mouse position:
				if (!isMouseWithinDeadAreaX(mouse_x)) {
					if (mouse_x <  x + Std.int((size - dead_area) / 2)            ) left  = true;
					if (mouse_x >= x + Std.int((size - dead_area) / 2) + dead_area) right = true;
				}
				// Same of up and down:
				if (!isMouseWithinDeadAreaY(mouse_y)) {
					if (mouse_y <  y + Std.int((size - dead_area) / 2)            ) up   = true;
					if (mouse_y >= y + Std.int((size - dead_area) / 2) + dead_area) down = true;
				}
			}
		}
	}
	
	//
	// Mouse handlers
	//
	// Call these when the mouse handlers in your Game-class are called
	//
	
	public function mouseMove(mouse_x: Int, mouse_y: Int) {
		updateDirection(mouse_x, mouse_y);
	}
	
	public function mouseDown(mouse_x: Int, mouse_y: Int) {
		if (checkMouseCollision(mouse_x, mouse_y)) {
			user_is_interacting = true;
			updateDirection(mouse_x, mouse_y);
		}
	}
	
	public function mouseUp(mouse_x: Int, mouse_y: Int) {
		user_is_interacting = false;
	}
	
	//
	// checkMouseCollision()
	//
	// Checks if the mouse or touch is on the virtual dpad.
	// Here, this is just a simple rectangle collision test.
	// If your dpad has another shape, override this function.
	//
	public function checkMouseCollision(mouse_x: Int, mouse_y: Int): Bool {
		if ((mouse_x >= x) && (mouse_y >= y) && (mouse_x < x + size) && (mouse_y < y + size)) return true;
		return false;
	}
	
	//
	// isMouseWithinMoveArea()
	// isMouseWithinDeadAreaX()
	// isMouseWithinDeadAreaY()
	//
	// Further functions for collision/direction detection.
	// You may want to override these, too.
	//
	
	public function isMouseWithinMoveArea(mouse_x: Int, mouse_y: Int): Bool {
		if ((mouse_x >= x + Std.int((size - move_area) / 2)) && (mouse_x < x + Std.int((size - move_area) / 2) + move_area) &&
		   ((mouse_y >= y + Std.int((size - move_area) / 2)) && (mouse_y < y + Std.int((size - move_area) / 2) + move_area))) return true;
		return false;
	}
		
	public function isMouseWithinDeadAreaX(mouse_x: Int): Bool {
		if ((mouse_x >= x + Std.int((size - dead_area) / 2)) && (mouse_x < x + Std.int((size - dead_area) / 2) + dead_area)) return true;
		return false;
	}

	public function isMouseWithinDeadAreaY(mouse_y: Int): Bool {
		if ((mouse_y >= y + Std.int((size - dead_area) / 2)) && (mouse_y < y + Std.int((size - dead_area) / 2) + dead_area)) return true;
		return false;
	}

	//
	// render() function.
	// Please override this with your own function.
	//
	public function render(painter: Painter) {
		// Draw the virtual dpad
		if (user_is_interacting) {
			painter.setColor(255, 0, 0); // Red
		}
		else {
			painter.setColor(255, 255, 255); // White
		}
		// Border
		painter.drawRect(x, y, size, size);
		// Cross
		painter.drawRect(x + Std.int((size - dead_area) / 2), y                                  , dead_area, size);
		painter.drawRect(x                                  , y + Std.int((size - dead_area) / 2), size, dead_area);
		// Center of cross
		painter.setColor(0, 0, 0); // Black
		//painter.drawRect(x + Std.int(size / 2) - dead_area, y + Std.int(size / 2) - dead_area, dead_area * 2 + 1, dead_area * 2 + 1);
	}
}
