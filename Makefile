# FLIP'S PYTHIA/FASTJET MAKEFILE, June 2012
# For: RPV gluino
# pt267@cornell.edu
#

# If you're not Flip, you'll want to change these appropriately
# -------------------------------------------------------------
PYTHIA		= /Users/fliptomato/Documents/Code/pythia8165
FASTJET		= /Users/fliptomato/Documents/Code/fastjet-3.0.1
#
# Alternately, you can change these when you call make, e.g.
#	make PYTHIA="/Users/someone_else/location/pythia8162"
#
# This should be the only thing that you need to change.


# Derived from your installation locations
# ----------------------------------------
PYTHIA_LIB 	= $(PYTHIA)/lib/archive
PYTHIA_INC 	= $(PYTHIA)/include
FASTJETINC	= `$(FASTJET)/bin/fastjet-config --cxxflags --plugins`
FASTJETLIB	= `$(FASTJET)/bin/fastjet-config --libs --plugins`

# COMPILER AND FLAGS
# ------------------
CPP 		= g++
CXXFLAGS 	= -O2 -ansi -pedantic -W -Wall -Wshadow -fbounds-check
# FLAGS:
#	-O2			"optimize more" (-O0 for debug, -O2 for shipping)
#	-ansi		remove GNU extensions that conflict with ISO C++
#	-pedantic	warnings to demand strict ISO C++ compliance
#	-W			warnings
#	-Wall		show all warnings messages for possible errors
#	-Wshadow	warnings about, e.g., duplicate variable names
#	-fbounds...	checks that indices stay within their range

# LIST OF DEPENDENCIES
# --------------------
AUXCPP = FlipEfficiency.cpp FlipEfficiencySignal.cpp FlipCommandFileFixer.cpp
AUXH = FlipEfficiency.h FlipCommandFileFixer.h 

# This is the default rule (first one in the list)
# It's good etiquette to start with  an 'all' rule
# ------------------------------------------------
all: PartonRPV instructions


# MAIN PROGRAM
# ------------
PartonRPV: PartonRPV.cc $(AUXCPP) $(AUXH)
	@$(CPP) -I $(PYTHIA_INC) $@.cc \
	$(AUXCPP) \
	$(FASTJETINC) \
	$(CXXFLAGS) -o $@ \
	-L $(PYTHIA_LIB) -l pythia8 -l lhapdfdummy \
	-L $(FASTJET)/lib \
	$(FASTJETLIB)


#	FLAGS
#	-----
#	@  Tells Make not to announce what command its giving
#	-I $(PYTHIA_INC) look for header files in the include directory
#	-L $(PYTHIA_LIB) links to the Pythia archive directory
# 	-l (lowercase 'L') links a particular library
#	... note that usually there's no space: -L$(PYTHIA_LIB)
#	... or -lpythia8 -llhapdfdummy
# 	
#	REMARKS
#	-------
# 	In the Pythia examples, this is listed as a dependency... why?
#		$(PYTHIA_LIB)/libpythia8.a


# JUST COMMENTS
# -------------
instructions: 
	@echo 
	@echo INSTRUCTIONS FOR RUNNING THIS PROGRAM
	@echo -------------------------------------
	@echo Type in the following to run:
	@echo ./PartonRPV 
	@echo 
	@echo Can also append optional arguments, for example:
	@echo ./PartonRPV [mstop] [mglu] [SigReg] [cmnd] [output] [spc]
	@echo ./PartonRPV 300 800 8 CmndShort.cmnd output.dat template.spc
	@echo
	@echo


.PHONY: instructions
# .PHONY tells the Makefile to ignore extant objects with these names
# i.e. it will run the rules without looking if these objects exist.
# This is usually used to tell the Makefile to do certain things 
# without necessarily generating an output file.


#  +-----------------------------------+	
#  | NO ADDITIONAL COMMANDS BELOW THIS |
#  +-----------------------------------+	

# To use:   If filename is Makefile, just type in 'make' at the command prompt.
#           Otherwise, type in "make -f FILENAME"
#			See bottom of document for more introductory notes on Makefiles.
#
# Pedagogical notes: break lines with: ' \'

# MAKE RULES
# ----------
# The general format of a Makefile rule is:
# output_files (TARGET) : input_files (DEPENDENCY)
#	shell commands (ACTION)
#
# If any DEPENDENCIES are newer than the TARGET, then the ACTION
# is taken to update the TARGET.
#
# Make will attempt to build the first TARGET in the Makefile unless
# you tell it to make a different target when you call it.

# PATTERN RULES
# -------------
# The character % is used as a wildcard to help specify pattern rules, e.g.:
#	%.o: %.c
#		$(CXX) $(CXXFLAGS) $(input) -o $(output)
#
# Note the use the $(input) and $(output) automatic variables. These correspond
# to the first DEPENDENCY and TARGET files. Also the plurals: $(inputs), etc.
# Perhaps easier to use:
# 	$@	name of the target
#	$<	name of the first dependency (I write this as $@.cc)

# REFERENCES
# ----------
# A giant sample Pythia makefile can be found in the examples directory
# * http://www.cprogramming.com/tutorial/makefiles_continued.html
# * http://makepp.sourceforge.net/1.19/makepp_tutorial.html#A%20simple%20makefile
# * http://www.cs.duke.edu/courses/cps108/doc/makefileinfo/sample.html
# * http://www.makelinux.net/make3/toc
# * http://www.jfranken.de/homepages/johannes/vortraege/make_inhalt.en.html
