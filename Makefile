APP = FillHashTable
SRC = test/main.c
CC = gcc
CFLAGS = -Wall -Wextra -Wstrict-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Werror
DPDK_CFLAGS = $(shell pkg-config --cflags libdpdk)
DPDK_LDFLAGS = $(shell pkg-config --libs libdpdk)
INST = installScript.sh

all: prepare hugepages build
prepare:
	./$(INST)
	curl -O https://fast.dpdk.org/rel/dpdk-24.03.tar.xz
	tar -xJf dpdk-24.03.tar.xz
	meson setup dpdk-24.03.tar.xz
	ninja -C dpdk-24.03/build
	sudo meson install -C dpdk-24.03/build
	sudo ldconfig
	rm -r dpdk-24.03.tar.xz	
	rm -rf dpdk-24.03

hugapages:
	echo 2048 | sudo tee /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages >/dev/null
	sudo mkdir /mnt/huge
	sudo mount -t hugetlbfs pagesize=1GB /mnt/huge

build:
	$(CC) $(CFLAGS) $(DPDK_CFLAGS) $(SRC) -o $(APP) $(DPDK_LDFLAGS)

run:
	sudo ./$(APP)
	
clean: 
	rm -f $(APP)
	sudo rm -rf /mnt/huge

