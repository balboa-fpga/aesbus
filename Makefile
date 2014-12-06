all:
	xst -intstyle ise -ifn "aes_bus.xst" -ofn "aes_bus.syr"
	ngdbuild -dd _ngo -nt timestamp -i -p xc6slx45-csg324-3 aes_bus.ngc aes_bus.ngd
	map -p xc6slx45-csg324-3 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt off -ir off -pr off -lc off -power off -o aes_bus_map.ncd aes_bus.ngd aes_bus.pcf
	par -w -ol high -mt off aes_bus_map.ncd aes_bus.ncd aes_bus.pcf
	trce -v 3 -s 3 -n 3 -fastpaths -xml aes_bus.twx aes_bus.ncd -o aes_bus.twr aes_bus.pcf
