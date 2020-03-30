package render.citrusGL.programs;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.utils.Float32Array;
import mme.math.glmatrix.Mat4Tools;
import render.citrusGL.objects.GLWall;

import hxdoom.Engine;
import hxdoom.common.Environment;
import hxdoom.abstracts.Angle;
import hxdoom.lumps.map.Segment;

/**
 * ...
 * @author Kaelan
 */
class GLMapGeometry 
{
	var gl:WebGLRenderContext;
	var program:GLProgram;
	
	var vertex_shader:GLShader;
	var fragment_shader:GLShader;
	
	var planes:Map<Segment, Array<GLWall>>;
	
	var safeToRender:Bool = false;
	
	public function new(_gl:WebGLRenderContext)
	{
		gl = _gl;
		program = gl.createProgram();
		
		vertex_shader = gl.createShader(gl.VERTEX_SHADER);
		fragment_shader = gl.createShader(gl.FRAGMENT_SHADER);
				
		gl.shaderSource(vertex_shader, GLMapGeometry.vertex_source);
		gl.shaderSource(fragment_shader, GLMapGeometry.fragment_source);
		
		gl.compileShader(vertex_shader);
		if (!gl.getShaderParameter(vertex_shader, gl.COMPILE_STATUS)) {
			throw ("Map Vertex Shadder error: \n" + gl.getShaderInfoLog(vertex_shader));
		}
		
		gl.compileShader(fragment_shader);
		if (!gl.getShaderParameter(fragment_shader, gl.COMPILE_STATUS)) {
			throw ("Map Fragment Shader error: \n" + gl.getShaderInfoLog(fragment_shader));
		}
		
		program = gl.createProgram();
			
		gl.attachShader(program, vertex_shader);
		gl.attachShader(program, fragment_shader);
			
		gl.linkProgram(program);
		
	}
	
	public function buildMapGeometry() {
		trace("Beep");
		
		safeToRender = false;
		
		planes = new Map();
		var mapSegments = Engine.ACTIVEMAP.segments;
		
		var numplanes:Int = 0;
		for (seg in mapSegments) {
			
			planes[seg] = new Array();
			
			if (seg.lineDef.solid) {
				planes[seg][0] = new GLWall(gl, seg, SideType.SOLID);
				continue;
			} else {
				planes[seg][0] = new GLWall(gl, seg, SideType.FRONT_BOTTOM);
				planes[seg][1] = new GLWall(gl, seg, SideType.FRONT_MIDDLE);
				planes[seg][2] = new GLWall(gl, seg, SideType.FRONT_TOP);
				planes[seg][3] = new GLWall(gl, seg, SideType.BACK_BOTTOM);
				planes[seg][4] = new GLWall(gl, seg, SideType.BACK_MIDDLE);
				planes[seg][5] = new GLWall(gl, seg, SideType.BACK_TOP);
			}
		}
		
		safeToRender = true;
	}
	
	public function render(_winWidth:Int, _winHeight:Int) {
		
		if (!safeToRender) return;
		
		var worldArray = new Float32Array(16);
		var viewArray = new Float32Array(16);
		var projArray = new Float32Array(16);
		
		var p_subsector = Engine.ACTIVEMAP.getPlayerSubsector();
		var p_segment = p_subsector.segments[0];
		var p_viewheight = p_segment.frontSector.floorHeight + 41;
		
		Mat4Tools.identity(worldArray);
		Mat4Tools.lookAt(	[Engine.ACTIVEMAP.actors_players[0].xpos, Engine.ACTIVEMAP.actors_players[0].ypos, p_viewheight], 
							[Engine.ACTIVEMAP.actors_players[0].xpos_look, Engine.ACTIVEMAP.actors_players[0].ypos_look, p_viewheight + Engine.ACTIVEMAP.actors_players[0].zpos_look], 
							[0, 0, 1], viewArray);
		Mat4Tools.perspective(45 * (Math.PI / 180), 320 / 200, 0.1, 10000, projArray);
		
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_World"), false, worldArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_View"), false, viewArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_Proj"), false, projArray);
		
		var lastseg:Null<Segment> = null;
		for (vis_seg in Engine.RENDER.virtual_screen) {
			if (lastseg == null || vis_seg != lastseg) {
				for (plane in planes[vis_seg]) {
					if (plane == null) continue;
					plane.bind(program);
					plane.render();
				}
				lastseg = vis_seg;
			} else {
				continue;
			}
		}
	}
	
	/*public function buildMapArray() {
		
		var loadedsegs = Engine.ACTIVEMAP.getVisibleSegments();
		var sectors = Engine.ACTIVEMAP.sectors;
		var numSegs = ((loadedsegs.length -1) * 42);
		map_lineverts.resize(numSegs);
		var itemCount:Int = 0;
		
		for (segs in 0...loadedsegs.length) {
			
			if (loadedsegs[segs].lineDef.solid) {
			
				map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				++itemCount;
			}
			else {
				
				if (loadedsegs[segs].lineDef.frontSideDef.lower_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.frontSideDef.middle_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.frontSideDef.upper_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.backSideDef.lower_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.backSideDef.middle_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.backSideDef.upper_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					++itemCount;
				}
			}
		}
		
		Environment.NEEDS_TO_REBUILD_AUTOMAP = false;
	}*/
	
	public static var vertex_source:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'attribute vec3 V3_POSITION;',
	'attribute vec4 V4_COLOR;',
	'varying vec4 F_COLOR;',
	'uniform mat4 M4_World;',
	'uniform mat4 M4_View;',
	'uniform mat4 M4_Proj;',
	'',
	'void main()',
	'{',
	'	F_COLOR = V4_COLOR;',
	'	gl_Position = M4_Proj * M4_View * M4_World * vec4(V3_POSITION, 1.0);',
	'}'
	].join('\n');
	
	public static var fragment_source:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'varying vec4 F_COLOR;',
	'',
	'void main()',
	'{',
	' 	gl_FragColor = F_COLOR;',
	'}'
	].join('\n');
	
}