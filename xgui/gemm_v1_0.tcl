# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ACC_IDX_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ACC_MEM_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ACC_MEM_WREN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ACC_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INP_IDX_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INP_MEM_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INP_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OUT_MEM_WREN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UOP_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UPC_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WGT_IDX_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WGT_MEM_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WGT_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.ACC_IDX_WIDTH { PARAM_VALUE.ACC_IDX_WIDTH } {
	# Procedure called to update ACC_IDX_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACC_IDX_WIDTH { PARAM_VALUE.ACC_IDX_WIDTH } {
	# Procedure called to validate ACC_IDX_WIDTH
	return true
}

proc update_PARAM_VALUE.ACC_MEM_WIDTH { PARAM_VALUE.ACC_MEM_WIDTH } {
	# Procedure called to update ACC_MEM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACC_MEM_WIDTH { PARAM_VALUE.ACC_MEM_WIDTH } {
	# Procedure called to validate ACC_MEM_WIDTH
	return true
}

proc update_PARAM_VALUE.ACC_MEM_WREN { PARAM_VALUE.ACC_MEM_WREN } {
	# Procedure called to update ACC_MEM_WREN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACC_MEM_WREN { PARAM_VALUE.ACC_MEM_WREN } {
	# Procedure called to validate ACC_MEM_WREN
	return true
}

proc update_PARAM_VALUE.ACC_WIDTH { PARAM_VALUE.ACC_WIDTH } {
	# Procedure called to update ACC_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACC_WIDTH { PARAM_VALUE.ACC_WIDTH } {
	# Procedure called to validate ACC_WIDTH
	return true
}

proc update_PARAM_VALUE.INP_IDX_WIDTH { PARAM_VALUE.INP_IDX_WIDTH } {
	# Procedure called to update INP_IDX_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INP_IDX_WIDTH { PARAM_VALUE.INP_IDX_WIDTH } {
	# Procedure called to validate INP_IDX_WIDTH
	return true
}

proc update_PARAM_VALUE.INP_MEM_WIDTH { PARAM_VALUE.INP_MEM_WIDTH } {
	# Procedure called to update INP_MEM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INP_MEM_WIDTH { PARAM_VALUE.INP_MEM_WIDTH } {
	# Procedure called to validate INP_MEM_WIDTH
	return true
}

proc update_PARAM_VALUE.INP_WIDTH { PARAM_VALUE.INP_WIDTH } {
	# Procedure called to update INP_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INP_WIDTH { PARAM_VALUE.INP_WIDTH } {
	# Procedure called to validate INP_WIDTH
	return true
}

proc update_PARAM_VALUE.INS_WIDTH { PARAM_VALUE.INS_WIDTH } {
	# Procedure called to update INS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INS_WIDTH { PARAM_VALUE.INS_WIDTH } {
	# Procedure called to validate INS_WIDTH
	return true
}

proc update_PARAM_VALUE.OUT_MEM_WREN { PARAM_VALUE.OUT_MEM_WREN } {
	# Procedure called to update OUT_MEM_WREN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUT_MEM_WREN { PARAM_VALUE.OUT_MEM_WREN } {
	# Procedure called to validate OUT_MEM_WREN
	return true
}

proc update_PARAM_VALUE.UOP_WIDTH { PARAM_VALUE.UOP_WIDTH } {
	# Procedure called to update UOP_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UOP_WIDTH { PARAM_VALUE.UOP_WIDTH } {
	# Procedure called to validate UOP_WIDTH
	return true
}

proc update_PARAM_VALUE.UPC_WIDTH { PARAM_VALUE.UPC_WIDTH } {
	# Procedure called to update UPC_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UPC_WIDTH { PARAM_VALUE.UPC_WIDTH } {
	# Procedure called to validate UPC_WIDTH
	return true
}

proc update_PARAM_VALUE.WGT_IDX_WIDTH { PARAM_VALUE.WGT_IDX_WIDTH } {
	# Procedure called to update WGT_IDX_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WGT_IDX_WIDTH { PARAM_VALUE.WGT_IDX_WIDTH } {
	# Procedure called to validate WGT_IDX_WIDTH
	return true
}

proc update_PARAM_VALUE.WGT_MEM_WIDTH { PARAM_VALUE.WGT_MEM_WIDTH } {
	# Procedure called to update WGT_MEM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WGT_MEM_WIDTH { PARAM_VALUE.WGT_MEM_WIDTH } {
	# Procedure called to validate WGT_MEM_WIDTH
	return true
}

proc update_PARAM_VALUE.WGT_WIDTH { PARAM_VALUE.WGT_WIDTH } {
	# Procedure called to update WGT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WGT_WIDTH { PARAM_VALUE.WGT_WIDTH } {
	# Procedure called to validate WGT_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.UOP_WIDTH { MODELPARAM_VALUE.UOP_WIDTH PARAM_VALUE.UOP_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UOP_WIDTH}] ${MODELPARAM_VALUE.UOP_WIDTH}
}

proc update_MODELPARAM_VALUE.UPC_WIDTH { MODELPARAM_VALUE.UPC_WIDTH PARAM_VALUE.UPC_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UPC_WIDTH}] ${MODELPARAM_VALUE.UPC_WIDTH}
}

proc update_MODELPARAM_VALUE.INS_WIDTH { MODELPARAM_VALUE.INS_WIDTH PARAM_VALUE.INS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INS_WIDTH}] ${MODELPARAM_VALUE.INS_WIDTH}
}

proc update_MODELPARAM_VALUE.INP_WIDTH { MODELPARAM_VALUE.INP_WIDTH PARAM_VALUE.INP_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INP_WIDTH}] ${MODELPARAM_VALUE.INP_WIDTH}
}

proc update_MODELPARAM_VALUE.WGT_WIDTH { MODELPARAM_VALUE.WGT_WIDTH PARAM_VALUE.WGT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WGT_WIDTH}] ${MODELPARAM_VALUE.WGT_WIDTH}
}

proc update_MODELPARAM_VALUE.ACC_WIDTH { MODELPARAM_VALUE.ACC_WIDTH PARAM_VALUE.ACC_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACC_WIDTH}] ${MODELPARAM_VALUE.ACC_WIDTH}
}

proc update_MODELPARAM_VALUE.ACC_MEM_WIDTH { MODELPARAM_VALUE.ACC_MEM_WIDTH PARAM_VALUE.ACC_MEM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACC_MEM_WIDTH}] ${MODELPARAM_VALUE.ACC_MEM_WIDTH}
}

proc update_MODELPARAM_VALUE.INP_MEM_WIDTH { MODELPARAM_VALUE.INP_MEM_WIDTH PARAM_VALUE.INP_MEM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INP_MEM_WIDTH}] ${MODELPARAM_VALUE.INP_MEM_WIDTH}
}

proc update_MODELPARAM_VALUE.WGT_MEM_WIDTH { MODELPARAM_VALUE.WGT_MEM_WIDTH PARAM_VALUE.WGT_MEM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WGT_MEM_WIDTH}] ${MODELPARAM_VALUE.WGT_MEM_WIDTH}
}

proc update_MODELPARAM_VALUE.ACC_IDX_WIDTH { MODELPARAM_VALUE.ACC_IDX_WIDTH PARAM_VALUE.ACC_IDX_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACC_IDX_WIDTH}] ${MODELPARAM_VALUE.ACC_IDX_WIDTH}
}

proc update_MODELPARAM_VALUE.INP_IDX_WIDTH { MODELPARAM_VALUE.INP_IDX_WIDTH PARAM_VALUE.INP_IDX_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INP_IDX_WIDTH}] ${MODELPARAM_VALUE.INP_IDX_WIDTH}
}

proc update_MODELPARAM_VALUE.WGT_IDX_WIDTH { MODELPARAM_VALUE.WGT_IDX_WIDTH PARAM_VALUE.WGT_IDX_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WGT_IDX_WIDTH}] ${MODELPARAM_VALUE.WGT_IDX_WIDTH}
}

proc update_MODELPARAM_VALUE.ACC_MEM_WREN { MODELPARAM_VALUE.ACC_MEM_WREN PARAM_VALUE.ACC_MEM_WREN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACC_MEM_WREN}] ${MODELPARAM_VALUE.ACC_MEM_WREN}
}

proc update_MODELPARAM_VALUE.OUT_MEM_WREN { MODELPARAM_VALUE.OUT_MEM_WREN PARAM_VALUE.OUT_MEM_WREN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUT_MEM_WREN}] ${MODELPARAM_VALUE.OUT_MEM_WREN}
}

