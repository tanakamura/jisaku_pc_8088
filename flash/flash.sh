make -C ../demo || exit 1
openocd -f flash.tcl
