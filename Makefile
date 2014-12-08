PROJ:=aes_bus
all:
	xst -intstyle ise -ifn "$(PROJ).xst" -ofn "$(PROJ).syr"
	ngdbuild -dd _ngo -nt timestamp -uc $(PROJ).ucf -p xc6slx45-csg324-3 $(PROJ).ngc $(PROJ).ngd
	map -p xc6slx45-csg324-3 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt off -ir off -pr off -lc off -power off -o $(PROJ)_map.ncd $(PROJ).ngd $(PROJ).pcf
	par -w -ol high -mt off $(PROJ)_map.ncd $(PROJ).ncd $(PROJ).pcf
	trce -v 3 -s 3 -n 3 -fastpaths -xml $(PROJ).twx $(PROJ).ncd -o $(PROJ).twr $(PROJ).pcf -ucf $(PROJ).ucf
	bitgen -w -g DebugBitstream:No -g Binary:yes -g CRC:Enable -g Reset_on_err:No -g ConfigRate:2 -g ProgPin:PullUp -g TckPin:PullUp -g TdiPin:PullUp -g TdoPin:PullUp -g TmsPin:PullUp -g UnusedPin:PullDown -g UserID:0xFFFFFFFF -g ExtMasterCclk_en:No -g SPI_buswidth:1 -g TIMER_CFG:0xFFFF -g multipin_wakeup:No -g StartUpClk:CClk -g DONE_cycle:4 -g GTS_cycle:5 -g GWE_cycle:6 -g LCK_cycle:NoWait -g Security:None -g DonePipe:Yes -g DriveDone:No -g en_sw_gsr:No -g drive_awake:No -g sw_clk:Startupclk -g sw_gwe_cycle:5 -g sw_gts_cycle:4 $(PROJ).ncd
