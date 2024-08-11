@tool
extends VisualShaderNodeCustom
class_name VisualShader3DRotation

func _get_category():
	return "CanvasItems"
	
func _get_global_code(mode):
	match get_option_index(0):
		0:
			return """
			vec3 degToRad(vec3 a) {
				return a * PI / 180.0;
			}
			
			const bool isInRadians = true;
			"""
		1:
			return """
			vec3 degToRad(vec3 a) {
				return a * PI / 180.0;
			}
			
			const bool isInRadians = false;
			"""

func _get_code(input_vars, output_vars, mode, type):
	return """
	vec3 angle = %s;
	vec2 v_in = %s;
	vec2 v_out;
	
	if (!isInRadians) angle = degToRad(angle);
	
	float cosX = cos(angle.x);
	float cosY = cos(angle.y);
	float cosZ = cos(angle.z);
	float sinX = sin(angle.x);
	float sinY = sin(angle.y);
	float sinZ = sin(angle.z);
	
	mat3 finalRot;
	finalRot[0][0] = cosZ * cosY;
	finalRot[1][0] = cosZ * sinY * sinX - sinZ * cosX;
	finalRot[2][0] = sinZ * sinX + cosZ * sinY * cosX;
	
	finalRot[0][1] = sinZ * cosY;
	finalRot[1][1] = cosZ * cosX + sinZ * sinY * sinX;
	finalRot[2][1] = sinZ * sinY * cosX - cosZ * sinX;
	
	finalRot[0][2] = -sinY;
	finalRot[1][2] = cosY * sinX;
	finalRot[2][2] = cosY * cosX;
	
	vec3 pos = vec3(v_in.xy, 0) * finalRot;
	v_out = pos.xy;
	
	%s = v_out;
	
	""" % [input_vars[0], input_vars[1], output_vars[0]]
	
func _get_default_input_port(type):
	return VisualShaderNode.PORT_TYPE_VECTOR_2D

func _get_description():
	return "This shader tries to simulate a 3D rotation on CanvasItems."
	
func _get_func_code(mode, type):
	return ""
	
func _get_input_port_count():
	return 2
	
func _get_input_port_default_value(port):
	match port:
		0:
			return Vector3.ZERO
		1:
			return Vector2.ZERO
	
func _get_input_port_name(port):
	match port:
		0:
			return "angle"
		1:
			return "vertex_in"
	
func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_3D
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D

func _get_name():
	return "Rotation 3D"
	
func _get_output_port_count():
	return 1
	
func _get_output_port_name(port):
	return "vertex_out"
	
func _get_output_port_type(port):
	return VisualShaderNode.PORT_TYPE_VECTOR_2D
	
func _get_property_count():
	return 1
	
func _get_property_default_index(index):
	return 1
	
func _get_property_name(index):
	return "Angle Type"
	
func _get_property_options(index):
	return ["Radians", "Degrees"]
	
@warning_ignore("unused_parameter")
func _is_available(mode, type):
	return type == VisualShader.TYPE_VERTEX
	
func _is_highend():
	return false
