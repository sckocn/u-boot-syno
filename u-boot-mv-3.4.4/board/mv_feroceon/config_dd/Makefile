include mvRules.mk


# Objects list

COMMON_OBJS     = $(COMMON_DIR)/mvCommon.o

OSSERVICES_OBJS    = $(OSSERVICES_DIR)/mvOs.o $(OSSERVICES_DIR)/mvOsSata.o 

BOARD_OBJS =	$(BOARD_ENV_DIR)/mvBoardEnvLib.o $(BOARD_ENV_DIR)/mvBoardEnvSpec.o

HAL_OBJS =	$(HAL_FLASH_DIR)/mvFlash.o $(HAL_FLASH_DIR)/mvAmdFlash.o $(HAL_FLASH_DIR)/mvIntelFlash.o \
		$(HAL_FLASH_DIR)/mvFlashCom.o $(HAL_SPD_DIR)/mvSpd.o $(HAL_DRAM_DIR)/mvDramIf.o \
		$(HAL_SATA_CORE_DIR)/mvSata.o $(HAL_SATA_CORE_DIR)/mvStorageDev.o \
                $(HAL_SATA_CORE_DIR)/mvLog.o $(HAL_SFLASH_DIR)/mvSFlash.o \
		$(HAL_ETHPHY_DIR)/mvEthPhy.o $(HAL_RTC_DIR)/mvDS133x.o \
		$(HAL_CNTMR_DIR)/mvCntmr.o $(HAL_TWSI_DIR)/mvTwsi.o \
                $(HAL_UART_DIR)/mvUart.o $(HAL_GPP_DIR)/mvGpp.o       \
                $(HAL_MFLASH_DIR)/mvMFlash.o $(HAL_SPI_DIR)/mvSpi.o \
                $(HAL_MFLASH_DIR)/mvSMFlash.o $(HAL_MFLASH_DIR)/mvPMFlash.o \
                $(HAL_SPI_DIR)/mvSpiCmnd.o $(HAL_USB_DIR)/mvUsb.o \
		$(HAL_IDMA_DIR)/mvIdma.o $(HAL_XOR_DIR)/mvXor.o \
		$(HAL_ETH_GBE_DIR)/mvEth.o $(HAL_PCIIF_DIR)/mvPciIf.o \
		$(HAL_ETH_GBE_DIR)/mvEthDebug.o $(HAL_PEX_DIR)/mvPex.o \
		$(HAL_CESA_DIR)/mvMD5.o


SOC_OBJS = 	$(SOC_DIR)/mv_cmd.o $(SOC_DIR)/mv_dram.o $(SOC_DIR)/mv_main.o \
		$(SOC_DIR)/mv_service.o $(SOC_ENV_DIR)/mvCtrlEnvLib.o \
		$(SOC_ENV_DIR)/mvCtrlEnvAddrDec.o $(SOC_SYS_DIR)/mvAhbToMbus.o \
                $(SOC_SYS_DIR)/mvCpuIf.o $(SOC_SYS_DIR)/mvSysXor.o $(SOC_SYS_DIR)/mvSysDram.o\
		$(SOC_SYS_DIR)/mvSysGbe.o $(SOC_SYS_DIR)/mvSysIdma.o \
		$(SOC_SYS_DIR)/mvSysPex.o $(SOC_SYS_DIR)/mvSysSata.o $(SOC_SYS_DIR)/mvSysUsb.o \
		$(SOC_DEVICE_DIR)/mvDevice.o $(SOC_CPU_DIR)/mvCpu.o $(HAL_PCIIF_DIR)/pci_util/mvPciUtils.o

USP_OBJS        = $(USP_DIR)/mv_flash.o $(USP_DIR)/mv_serial.o \
                  $(USP_DIR)/mv_pageTable.o $(USP_DIR)/mv_rtc.o $(USP_DIR)/mv_mon_init.o \
                  $(USP_DIR)/mv_pci.o $(USP_DIR)/mv_nand.o \
                  $(USP_DIR)/mv_ide.o $(USP_DIR)/mv_egiga.o \
		  $(USP_DIR)/mv_fs.o $(USP_DIR)/mv_loadnet.o $(USP_DIR)/mv_protectionUnit.o \
  		  $(USP_DIR)/mv_i2c.o $(USP_DIR)/mv_ext2_boot.o  \
		  $(USP_DIR)/ethSwitch/mv_switch.o

ifeq ($(NAND_BOOT), y)
USP_OBJS        += $(USP_DIR)/nBootloader.o
endif
                  
SOBJS           = $(USP_DIR)/jump.o \
		  $(SOC_DIR)/platform.o \
                  $(HAL_DRAM_DIR)/mvDramIfBasicInit.o \
                  $(HAL_DRAM_DIR)/mvDramIfConfig.o \
                  $(HAL_TWSI_DIR)/mvTwsiEeprom.o
#                  $(SOC_SYS_DIR)/mvCpuIfInit.o

ifeq ($(NAND_BOOT), y)
SOBJS        += $(USP_DIR)/nBootstrap.o
endif
		  

OBJS            = $(COMMON_OBJS) $(OSSERVICES_OBJS) $(HAL_OBJS) $(SOC_OBJS) $(BOARD_OBJS) $(USP_OBJS) 

LIB             = lib$(BOARD).a

all:    $(LIB)

$(LIB): .depend $(SOBJS) $(OBJS)
	$(AR) crv $@ $(SOBJS) $(OBJS)

#########################################################################

.depend:        Makefile $(SOBJS:.o=.S) $(OBJS:.o=.c) $(USB_OBJS:.o=.c)
	$(CC) -M $(CFLAGS) $(SOBJS:.o=.S) $(OBJS:.o=.c) $(USB_OBJS:.o=.c) > $@

sinclude .depend

#########################################################################

