#===============================================================================
# Example run string: make TESTNAME={name_of_testcase} (optional)
#                     make TESTNAME=counter_test all
#===============================================================================

# Define variables
TESTNAME    ?= sanity_test
TB_NAME     ?= test_bench
RADIX       ?= decimal
MEALY_FSM   ?= 0

#===============================================================================
all: build run

all_wave: build run_wave

all_cov: build_cov run_cov

build:
	vlib work
	cp -rf ../testcases/$(TESTNAME).v run_test.v
	vmap work work
	vlog -f compile.f | tee compile.log

build_cov:
	vlib work
	vmap work work
	cp -rf ../testcases/$(TESTNAME).v run_test.v
	vlog +cover=bsecft -f compile.f

run:
	vsim -debugDB -l $(TESTNAME).log -voptargs=+acc -assertdebug -c $(TB_NAME) -do "log -r /*; run -all;" -GMEALY_FSM=$(MEALY_FSM)

run_cov:
	vsim -coverage -l $(TESTNAME).log -c $(TB_NAME) -voptargs="+cover=bsect" -assertdebug -do "coverage save -onexit $(TESTNAME).ucdb; log -r /*; run -all"

run_wave:
	vsim -i -view vsim.wlf -do "add wave vsim:/$(TB_NAME)/*; radix $(RADIX)" &
gen_cov:
  mkdir -p coverage
  vcover merge IP.ucdb *.ucdb
  vcover report IP.ucdb -output coverage/summary_report.txt
  vcover report -zeros -details -code bcesft -annotate -All -codeAll IP.ucdb -output coverage/detail_report.txt
gen_html:
  mkdir -p coverage
  vcover merge IP.ucdb *.ucdb
  vcover report -zeros -details -code bcesft -annotate -testhitdataAll -html IP.ucdb
view_cov:
  vsim -gui -viewcov IP.ucdb &
register_group:
  make all_cov TESTNAME=sanity_test
  make all_cov TESTNAME=wr_rd_check
  make all_cov TESTNAME=pstrb_chk
  make all_cov TESTNAME=halt_chk
  make all_cov TESTNAME=en_cnt
  make all_cov TESTNAME=cnt_mode_other
  make all_cov TESTNAME=cnt_mode0
  make all_cov TESTNAME=valid_itr
  make all_cov TESTNAME=rwlc_tisr
  make all_cov TESTNAME=invalid_itr_cases
  make all_cov TESTNAME=err_cases
  make all_cov TESTNAME=df_check_reg
  make all_cov TESTNAME=cnt_mode_def
  make all_cov TESTNAME=clr_cnt
clean:
  rm -rf work
  rm -rf vsim.dbg
  rm -rf *.ini
  rm -rf *.log
  rm -rf *.wlf
  rm -rf transcript
  rm -rf *.ucdb
  rm -rf coverage
  rm -rf report.txt
help:
  @echo ""
  @echo "***************************************************************************"
  @echo " make clean   : clean all compiled data"
  @echo " make build   : build the design"
  @echo " make build_cov : build the design in coverage mode"
  @echo " make run     : run simulation"
  @echo " make run_cov : run simulation in coverage mode"
  @echo " make all     : build and run simulation"
  @echo " make all_cov : build and run simulation in coverage mode"
  @echo " make wave    : open waveform"
  @echo " make gen_cov : merge, generate coverage data base and text coverage report"
  @echo " make register_group : build and run all testcases in coverage mode"
  @echo " make view_cov   : view coverage data in QuestaIntel Starter FPGA Edition"
  @echo "***************************************************************************"
  @echo ""
