package render.citrusGL.objects;

import hxdoom.lumps.map.Sector;
import hxdoom.lumps.map.Segment;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;

enum SideType {
	FRONT_TOP;
	FRONT_BOTTOM;
	FRONT_MIDDLE;
	BACK_TOP;
	BACK_BOTTOM;
	BACK_MIDDLE;
	SOLID;
}

/**
 * ...
 * @author Kaelan
 */
class GLWall 
{
	var gl:WebGLRenderContext;
	var plane_vertexes:Array<Float>;
	var segment:Segment;
	var type:SideType;
	var texturename:String;
	
	public function new(_context:WebGLRenderContext, _segment:Segment, _type:SideType) 
	{
		gl = _context;
		segment = _segment;
		type = _type;
		
		plane_vertexes = new Array();
		plane_vertexes.resize(42);
		
		buildVertexes(_type);
	}
	public function render(_program:GLProgram) {
		
		if (_program == null) return;
		
		if (texturename == "-") return;
		
		//check if wall is covered
		switch (type) {
			
			case SOLID :
				if (segment.frontSector.floorHeight == segment.frontSector.ceilingHeight) {
					return;
				}
			case FRONT_BOTTOM :
				if (segment.frontSector.floorHeight >= segment.backSector.floorHeight) {
					return;
				}
			case FRONT_TOP :
				if (segment.frontSector.ceilingHeight <= segment.backSector.ceilingHeight) {
					return;
				}
			case FRONT_MIDDLE | BACK_MIDDLE :
				if (segment.frontSector.floorHeight == segment.frontSector.ceilingHeight || segment.backSector.floorHeight == segment.backSector.ceilingHeight) {
					return;
				}
			default :
		}
		
		var loadedLineBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, loadedLineBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(plane_vertexes), gl.STATIC_DRAW);
		
		var posAttributeLocation:Null<Int> = gl.getAttribLocation(_program, "V3_POSITION");
		var colorAttributeLocation:Null<Int> = gl.getAttribLocation(_program, "V4_COLOR");
		
		if (posAttributeLocation == null || colorAttributeLocation == null) return;
		
		gl.vertexAttribPointer(
			posAttributeLocation,
			3,
			gl.FLOAT,
			false,
			7 * Float32Array.BYTES_PER_ELEMENT,
			0);
		gl.vertexAttribPointer(
			colorAttributeLocation,
			4,
			gl.FLOAT,
			false,
			7 * Float32Array.BYTES_PER_ELEMENT,
			3 * Float32Array.BYTES_PER_ELEMENT);
		gl.enableVertexAttribArray(posAttributeLocation);
		gl.enableVertexAttribArray(colorAttributeLocation);
		
		gl.useProgram(_program);
		
		if (plane_vertexes == null) return;
		gl.drawArrays(gl.TRIANGLES, 0, Std.int(plane_vertexes.length / 7));
	}
	
	function buildVertexes(_type:SideType) {
		
		var index = 0;
		
		switch(_type) {
			
			case SOLID:
				
				texturename = segment.lineDef.frontSideDef.middle_texture;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case FRONT_TOP:
				
				texturename = segment.lineDef.frontSideDef.upper_texture;
				
				plane_vertexes[index] 		= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case FRONT_MIDDLE:
				
				texturename = segment.lineDef.frontSideDef.middle_texture;
				
				var higherFloorSec:Sector = segment.frontSector.floorHeight >= segment.backSector.floorHeight ? segment.frontSector : segment.backSector;
				var lowerCeilingSec:Sector = segment.frontSector.ceilingHeight <= segment.backSector.ceilingHeight ? segment.frontSector : segment.backSector;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case FRONT_BOTTOM:
				
				texturename = segment.lineDef.frontSideDef.lower_texture;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case BACK_TOP:
				
				texturename = segment.lineDef.backSideDef.upper_texture;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case BACK_MIDDLE:
				
				texturename = segment.lineDef.backSideDef.middle_texture;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case BACK_BOTTOM:
				
				texturename = segment.lineDef.backSideDef.lower_texture;
		}
	}
	
}