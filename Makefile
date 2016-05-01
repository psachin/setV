#
#	Makefile for setV
#
# Usage:
# make clean  # Clean swap & garbage files

.PHONY = all clean

all:
	@echo "This just saved you from a terrible mistake!"

clean:
	@echo "Cleaning up..."
	-rm -rvf *~ \#* \%* *.o
